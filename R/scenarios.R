#' @export
load_scenario <- \(scenario_path) {
  try_java(
    rJava::.jnew("uk/ac/ox/poseidon/r/YamlScenarioLoader") |>
      rJava::.jcall("Luk/ac/ox/poseidon/simulations/api/Scenario;", "load", scenario_path)
  )
}

#' @export
new_simulation <- \(scenario_object) {
  try_java(
    scenario_object |>
      rJava::.jcall("Luk/ac/ox/poseidon/simulations/api/Simulation;", "newSimulation")
  )
}

#' @export
get_input_folder <- \(scenario_object) {
  try_java(
    scenario_object |>
      rJava::.jcall("Ljava/nio/file/Path;", "getInputFolder") |>
      rJava::.jcall("S", "toString")
  )
}

#' @export
set_input_folder <- \(scenario_object, ...) {
  args_list <- list2(...)
  if (vctrs::vec_is_empty(args_list)) {
    abort("Must supply at least one path component.")
  }
  if (!purrr::every(args_list, is_character)) {
    abort("`...` must be character arguments.")
  }
  args_vec <- sapply(args_list, enc2utf8)
  n <- vctrs::vec_size(args_vec)
  try_java(
    scenario_object |>
      rJava::.jcall(
        "V",
        "setInputFolder",
        args_vec[1],
        if (n > 1) rJava::.jarray(args_vec[2:n]) else character()
      )
  )
  scenario_object
}
