options(java.parameters = "-Xmx8g")
devtools::load_all()

input_folder <-
  fs::path_home("workspace", "POSEIDON", "epo", "epo_inputs")

scenario_path <-
  fs::path(input_folder, "tests", "scenarios", "EpoPathPlannerAbundanceScenario.yaml")

scenario <-
  load_scenario(scenario_path)

scenario |>
  get_parameters()

scenario |>
  set_parameter_value("inputFolder.path", input_folder)

sim <-
  scenario |>
  new_simulation()

sim |> step(360)

get_dataset_names(sim)

# daily_time_series <-
#   sim |>
#   get_dataset("Daily time series")
#
# daily_time_series |>
#   get_table_names() |>
#   purrr::map(\(table) daily_time_series |> get_table(table))
#
actions <-
  sim |>
  get_dataset("Purse-seiner events") |>
  get_table("Actions")

trips <-
  sim |>
  get_dataset("Purse-seiner events") |>
  get_table("Trips")
