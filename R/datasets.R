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
      \(col, column_name) {
        array <-
          col |>
          rJava::.jcall("Ljava/lang/Object;", "toArray", use.true.class = TRUE)
        if (rlang::is_atomic(array)) {
          class(array) <-
            col |>
            rJava::.jcall("[Ljava/lang/String;", "getS3Classes")
          array
        } else {
          simplify_list(array, paste("Extracting", column_name, "column"))
        }
      },
      .progress = list(
        show_after = 1,
        name = paste("Extracting", table_name, "table")
      )
    ) |>
    tibble::as_tibble()
}

get_java_table <- \(dataset_object, table_name) {
  key <- try_java(rJava::.jnew("java/lang/String", table_name))
  try_java(
    dataset_object |>
      rJava::.jcall("Luk/ac/ox/poseidon/datasets/api/Table;", "getTable", key)
  )
}
