#' @export
get_parameters <- \(scenario_object) {
  try_java(
    scenario_object |>
      rJava::.jcall("Ljava/util/Map;", "getParameters") |>
      rJava::.jcall("Ljava/util/Collection;", "values") |>
      lapply(\(p) tibble::tibble_row(
        name = p |>
          rJava::.jcall("S", "getName"),
        value = p |>
          rJava::.jcall("Ljava/lang/Object;", "getValue") |>
          rJava::.jcall("S", "toString")
      )) |>
      purrr::list_rbind()
  )
}

#' @export
get_parameter_value <- \(scenario_object, parameter_name) {
  try_java(
    scenario_object |>
      rJava::.jcall("Ljava/lang/Object;", "getParameterValue", parameter_name) |>
      simplify()
  )
}

#' @export
set_parameter_value <- \(scenario_object, parameter_name, value) {
  try_java({
    obj <-
      if (is.logical(value)) {
        rJava::.jnew("java/lang/Boolean", value)
      } else if (is.numeric(value)) {
        rJava::.jnew("java/lang/Double", value)
      } else {
        rJava::.jnew("java/lang/String", as.character(value))
      }
    scenario_object |>
      rJava::.jcall(
        "V",
        "setParameterValue",
        parameter_name,
        rJava::.jcast(obj)
      )
  })
  scenario_object |>
    get_parameter_value(parameter_name)
}
