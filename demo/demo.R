options(java.parameters = "-Xmx8g")
load_all()

input_folder <-
  fs::path_home("workspace", "POSEIDON", "POSEIDON", "inputs", "epo_inputs")

scenario_path <-
  fs::path(input_folder, "tests", "scenarios", "EpoPathPlannerAbundanceScenario.yaml")

scenario <-
  load_scenario(scenario_path) |>
  set_input_folder(input_folder)

sim <-
  scenario |>
  new_simulation()

for (i in 1:365) {
  step(sim)
  print(paste("Step", get_step(sim)))
}

sim |>  get_table_data("Purse-seiner events", "Actions")

sim |>  get_table_data("Purse-seiner events", "Trips")
