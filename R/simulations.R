#' @export
step <- \(simulations, num_steps = 1) {
  num_sims <- length(simulations)
  cli::pluralize("Stepping {num_sims} simulation{?s} {num_steps} time{?s}") |>
    cli::cli_progress_bar(total = num_steps)
  try_java({
    simulation_array <-
      simulations |>
      rJava::.jarray(
        contents.class = "uk/ac/ox/poseidon/simulations/api/Simulation"
      )
    for (i in 1:num_steps) {
      rJava::.jcall("uk/ac/ox/poseidon/r/Utils", "V", "step", simulation_array)
      cli::cli_progress_update()
    }
  })
  simulations
}

#' Returns the current time step of simulations.
#'
#' `get_step()` returns a numeric vector indicating the current time step of
#' each referenced simulation object. Those time steps usually (but not
#' necessarily) represent days.
#' @param simulations Either a single reference to a simulation object or a list
#'   of such references.
#' @returns A numeric vector of the same length as `simulations`.
#'
#' @export
get_step <- \(simulations) {
  try_java(
    c(simulations) |>
      purrr::map_int(\(sim) sim |> rJava::.jcall("I", "getStep"))
  )
}
