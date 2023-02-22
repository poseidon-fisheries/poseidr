options(java.parameters = "-Xmx8g")
load_all()

library(fs)

scenario_path <-
  # path_home(
  #   "workspace", "tuna", "np", "calibrations",
  #   "vps_holiday_runs", "without_betavoid_with_temp",
  #   "cenv0729", "2022-12-24_18.13.45_global", "calibrated_scenario.yaml"
  # )
  path_home(
    "workspace", "POSEIDON", "inputs", "epo_inputs", "tests", "scenarios", "EpoScenarioPathfinding.yaml"
  )

# tryCatch(load_scenario(scenario_path), Exception = \(e){
#   e$jobj$printStackTrace()
# })

scenario <-
  load_scenario(scenario_path) |>
  set_input_folder(fs::path_home("workspace", "POSEIDON", "inputs", "epo_inputs"))

scenario |> get_input_folder()

sim <-
  scenario |>
  new_simulation()

for (i in 1:20) {
  step(sim)
  print(paste("Step", get_step(sim)))
}
df <- get_table_data(sim, "Daily", "Skipjack tuna Catches (kg)")
plot(df)


# tryCatch(step(sim), Exception = \(e){
#   e$jobj$printStackTrace()
# })
