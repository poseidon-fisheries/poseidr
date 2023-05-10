#' @export
get_parameters <- \(scenario_object) {
  try_java(
    scenario_object |>
      rJava::.jcall("Ljava/util/Map;", "getParameters") |>
      rJava::.jcall("Ljava/util/Collection;", "values") |>
      lapply(\(p) tibble::tibble_row(
        name = rJava::.jcall(p, "S", "getName"),
        value = rJava::.jcall(p, "Ljava/lang/Object;", "getValue") |> rJava::.jsimplify()
      )) |>
      purrr::list_rbind()
  )
}

#' @export
get_parameter_value <- \(scenario_object, parameter_name) {
  try_java(
    scenario_object |>
      rJava::.jcall("Ljava/lang/Object;", "getParameterValue", parameter_name) |>
      rJava::.jsimplify()
  )
}

#' @export
set_parameter_value <- \(scenario_object, parameter_name, value) {
  try_java(
    scenario_object |>
      rJava::.jcall(
        "V",
        "setParameterValue",
        parameter_name,
        rJava::.jnew("java/lang/Double", value) |> rJava::.jcast()
      )
  )
}
