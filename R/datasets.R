#' @export
get_dataset_names <- \(simulation_object) {
  simulation_object |>
    rJava::.jcall("Ljava/util/Map;", "getDatasets") |>
    rJava::.jcall("Ljava/util/Set;", "keySet") |>
    sapply(rJava::.jsimplify)
}

#' @export
get_table_names <- \(simulation_object, dataset_name) {
  simulation_object |>
    get_java_dataset(dataset_name) |>
    rJava::.jcall("Ljava/util/Set;", "getTableNames") |>
    sapply(rJava::.jsimplify)
}

#' @export
get_table_data <- \(simulation_object, dataset_name, table_name) {
  table <-
    simulation_object |>
    get_java_table(dataset_name, table_name)
  as.data.frame(
    table |>
      rJava::.jcall("Ljava/util/Collection;", "getColumns") |>
      lapply(\(c) sapply(c, rJava::.jsimplify)),
    col.names = table |>
      rJava::.jcall("Ljava/util/List;", "getColumnNames") |>
      sapply(rJava::.jsimplify)
  )
}

make_java_map_key <- \(key) {
  rJava::.jnew("java/lang/String", key) |>
    rJava::.jcast()
}

get_java_dataset <- \(simulation_object, dataset_name) {
  key <- make_java_map_key(dataset_name)
  simulation_object |>
    rJava::.jcall("Ljava/util/Map;", "getDatasets") |>
    rJava::.jcall("Ljava/lang/Object;", "get", key)
}

get_java_table <- \(simulation_object, dataset_name, table_name) {
  key <- rJava::.jnew("java/lang/String", table_name)
  simulation_object |>
    get_java_dataset(dataset_name) |>
    rJava::.jcall("Luk/ac/ox/poseidon/datasets/api/Table;", "getTable", key)
}
