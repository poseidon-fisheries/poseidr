options(java.parameters = "-Xmx8g")

library(rJava)
library(fs)

scenario_path <-
  path_home(
    "workspace", "tuna", "np", "calibrations",
    "vps_holiday_runs", "without_betavoid_with_temp",
    "cenv0729", "2022-12-24_18.13.45_global", "calibrated_scenario.yaml"
  )

class_path <-
  path_home(
    "workspace", "POSEIDON", "poseidon-r", "build", "libs", "poseidon-r-all.jar"
  )

.jinit()
.jaddClassPath(class_path)

C <- \(name) paste0("uk/ac/ox/poseidon/", name)
L <- \(name) paste0("L", C(name), ";")

load_scenario <- \(scenario_path) {
  .jnew(C("r/YamlScenarioLoader")) |>
    .jcall(L("simulation/api/Scenario"), "load", scenario_path)
}

get_dataset_names <- \(sim) {
  sim |>
    .jcall("Ljava/util/Map;", "getDatasets") |>
    .jcall("Ljava/util/Set;", "keySet") |>
    sapply(.jsimplify)
}

make_java_map_key <- \(key) {
  .jcast(.jnew("java/lang/String", key))
}

get_java_dataset <- \(sim, dataset_name) {
  key <- .jcast(.jnew("java/lang/String", dataset_name))
  sim |>
    .jcall("Ljava/util/Map;", "getDatasets") |>
    .jcall("Ljava/lang/Object;", "get", key)
}

get_table_names <- \(sim, dataset_name) {
  sim |>
    get_java_dataset(dataset_name) |>
    .jcall("Ljava/util/Set;", "getTableNames") |>
    sapply(.jsimplify)
}

get_java_table <- \(sim, dataset_name, table_name) {
  key <- .jnew("java/lang/String", table_name)
  sim |>
    get_java_dataset(dataset_name) |>
    .jcall(L("datasets/api/Table"), "getTable", key)
}

get_table_data <- \(sim, dataset_name, table_name) {
  table <- get_java_table(sim, dataset_name, table_name)
  as.data.frame(
    table |>
      .jcall("Ljava/util/Collection;", "getColumns") |>
      lapply(\(c) sapply(c, .jsimplify)),
    col.names = table |>
      .jcall("Ljava/util/List;", "getColumnNames") |>
      sapply(.jsimplify)
  )
}

sim <-
  load_scenario(scenario_path) |>
  .jcall(L("simulation/api/Simulation"), "newSimulation")

for (i in 1:20) {
  .jcall(sim, "V", "step")
  print(paste("Step", .jcall(sim, "I", "getStep")))
}
df <- get_table_data(sim, "Daily", "Skipjack tuna Catches (kg)")
plot(df)
