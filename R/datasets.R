#' @export
get_dataset_names <- \(simulation_object) {
  try_java(
    simulation_object |>
      rJava::.jcall("Ljava/util/Map;", "getDatasets") |>
      rJava::.jcall("Ljava/util/Set;", "keySet") |>
      simplify_list()
  )
}

#' @export
get_dataset <- \(simulation_object, dataset_name) {
  key <- make_java_map_key(dataset_name)
  try_java(
    simulation_object |>
      rJava::.jcall("Ljava/util/Map;", "getDatasets") |>
      rJava::.jcall("Ljava/lang/Object;", "get", key)
  )
}

simplify_list <- \(xs, progress = TRUE) {
  xs |>
    as.list() |>
    purrr::map(simplify, .progress = progress) |>
    purrr::list_simplify()
}

#' @export
get_table_names <- \(dataset_object) {
  try_java(
    dataset_object |>
      rJava::.jcall("Ljava/util/List;", "getTableNames") |>
      simplify_list()
  )
}

#' @export
get_table <- \(dataset_object, table_name) {
  table <-
    dataset_object |>
    get_java_table(table_name)
  column_names <-
    table |>
    rJava::.jcall("Ljava/util/List;", "getColumnNames") |>
    simplify_list(paste("Getting", table_name, "column names"))
  table |>
    rJava::.jcall("Ljava/util/Collection;", "getColumns") |>
    as.list() |>
    set_names(column_names) |>
    purrr::map2(
      column_names,
      \(col, column_name) simplify_list(
        col,
        paste("Extracting", column_name, "column")
      ),
      .progress = list(
        show_after = 1,
        name = paste("Extracting", table_name, "table")
      )
    ) |>
    tibble::as_tibble()
}

simplify <- \(x) {
  if (rJava::is.jnull(x)) {
    NA
  } else {
    o <- rJava::.jsimplify(x)
    if (inherits(o, "jobjRef")) {
      s <- rJava::.jcall(o, "S", "toString")
      if (rJava::.jinstanceof(o, "java.time.LocalDateTime")) {
        lubridate::parse_date_time(s, "ymdHMS", truncated = 3)
      } else {
        s
      }
    } else {
      o
    }
  }
}

get_java_table <- \(dataset_object, table_name) {
  key <- try_java(rJava::.jnew("java/lang/String", table_name))
  try_java(
    dataset_object |>
      rJava::.jcall("Luk/ac/ox/poseidon/datasets/api/Table;", "getTable", key)
  )
}
