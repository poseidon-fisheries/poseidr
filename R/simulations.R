#' @export
step <- \(simulation_object) {
  simulation_object |>
    rJava::.jcall("V", "step")
  simulation_object
}

#' @export
get_step <- \(simulation_object) {
  simulation_object |>
    rJava::.jcall("I", "getStep")
}
