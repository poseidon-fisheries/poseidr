#' @export
get_dataset_names <- \(simulation_object) {
  try_java(
    simulation_object |>
      rJava::.jcall("Ljava/util/Map;", "getDatasets") |>
      rJava::.jcall("Ljava/util/Set;", "keySet") |>
      sapply(rJava::.jsimplify)
  )
}

#' @export
get_table_names <- \(simulation_object, dataset_name) {
  try_java(
    simulation_object |>
      get_java_dataset(dataset_name) |>
      rJava::.jcall("Ljava/util/List;", "getTableNames") |>
      sapply(rJava::.jsimplify)
  )
}

#' @export
get_table_data <- \(simulation_object, dataset_name, table_name) {
  table <-
    simulation_object |>
    get_java_table(dataset_name, table_name)
  column_names <-
    table |>
    rJava::.jcall("Ljava/util/List;", "getColumnNames") |>
    sapply(rJava::.jsimplify)
  table |>
    rJava::.jcall("Ljava/util/Collection;", "getColumns") |>
    lapply(\(c) purrr::list_simplify(lapply(c, simplify))) |>
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

make_java_map_key <- \(key) {
  try_java(
    rJava::.jnew("java/lang/String", key) |>
      rJava::.jcast()
  )
}

get_java_dataset <- \(simulation_object, dataset_name) {
  key <- make_java_map_key(dataset_name)
  try_java(
    simulation_object |>
      rJava::.jcall("Ljava/util/Map;", "getDatasets") |>
      rJava::.jcall("Ljava/lang/Object;", "get", key)
  )
}

get_java_table <- \(simulation_object, dataset_name, table_name) {
  key <- try_java(rJava::.jnew("java/lang/String", table_name))
  try_java(
    simulation_object |>
      get_java_dataset(dataset_name) |>
      rJava::.jcall("Luk/ac/ox/poseidon/datasets/api/Table;", "getTable", key)
  )
}
