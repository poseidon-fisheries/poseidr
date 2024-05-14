#' @export
step <- \(simulation_objects, num_steps = 1) {
  num_sims <- length(simulation_objects)
  cli::pluralize("Stepping {num_sims} simulation{?s} {num_steps} time{?s}") |>
    cli::cli_progress_bar(total = num_steps)
  try_java({
    simulation_array <-
      simulation_objects |>
      rJava::.jarray(
        contents.class = "uk/ac/ox/poseidon/simulations/api/Simulation"
      )
    for (i in 1:num_steps) {
      rJava::.jcall("uk/ac/ox/poseidon/r/Utils", "V", "step", simulation_array)
      cli::cli_progress_update()
    }
  })
  simulation_objects
}

#' @export
get_step <- \(simulation_objects) {
  try_java(
    simulation_objects |>
      purrr::map_int(\(sim) sim |> rJava::.jcall("I", "getStep"))
  )
}
