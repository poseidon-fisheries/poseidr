#' @export
step <- \(simulation_object, num_steps = 1) {
  try_java({
    paste("Stepping simulation", num_steps, "times") |>
      cli::cli_progress_bar(total = num_steps)
    for (i in 1:num_steps) {
      rJava::.jcall(simulation_object, "V", "step")
      cli::cli_progress_update()
    }
  })
  simulation_object
}

#' @export
get_step <- \(simulation_object) {
  try_java(
    simulation_object |>
      rJava::.jcall("I", "getStep")
  )
}
