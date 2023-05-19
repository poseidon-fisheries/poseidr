options(java.parameters = "-Xmx8g")
load_all()

input_folder <-
  fs::path_home("workspace", "POSEIDON", "POSEIDON", "inputs", "epo_inputs")

scenario_path <-
  fs::path(input_folder, "tests", "scenarios", "EpoPathPlannerAbundanceScenario.yaml")

scenario <-
  load_scenario(scenario_path) |>
  set_input_folder(input_folder)

scenario |>
  get_parameter_value("purseSeinerFleetFactory.destinationStrategyFactory.fadModuleFactory.dampen")

scenario |>
  set_parameter_value("purseSeinerFleetFactory.destinationStrategyFactory.fadModuleFactory.dampen", 0.75)

scenario |>
  get_parameter_value("purseSeinerFleetFactory.destinationStrategyFactory.fadModuleFactory.dampen")

sim <-
  scenario |>
  new_simulation()

sim |> step(1)

get_dataset_names(sim)

yearly_time_series <- sim |> get_dataset("Yearly time series")

sim |>
  get_dataset("Yearly time series") |>
  get_table_names()

sim |>
  get_dataset("Yearly time series") |>
  get_table("Total Hours Out")

actions <-
  sim |>
  get_dataset("Purse-seiner events") |>
  get_table("Actions")

trips <-
  sim |>
  get_table_data("Purse-seiner events", "Trips")
