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

simplify_list <- \(xs) {
  xs |>
    as.list() |>
    purrr::map(simplify, .progress = TRUE) |>
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
    simplify_list()
  table |>
    rJava::.jcall("Ljava/util/Collection;", "getColumns") |>
    as.list() |>
    purrr::map(as.list, .progress = TRUE) |>
    purrr::map(simplify_list, .progress = TRUE) |>
    set_names(column_names) |>
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
