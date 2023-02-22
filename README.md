# poseidr

The R interface to [POSEIDON](https://github.com/poseidon-fisheries/POSEIDON).

Caveat emptor: this is *extremely* embryonic work and barely functional at this point (not to mention undocumented and untested).

Still, it should be installable from R with:

```R
remotes::install_github("poseidon-fisheries/poseidr")
```

The POSEIDON JAR file is included in the package, so no separate installation POSEIDON installation required, but you do need to have an installed Java Runtime Environment (>= 8) that [rJava](https://rforge.net/rJava/) can pick up.

Here is an example of what's already possible:

```R
library(poseidr)

input_folder <-
  fs::path_home("workspace", "POSEIDON", "inputs", "epo_inputs")

scenario_path <-
  fs::path(input_folder, "tests", "scenarios", "EpoScenarioPathfinding.yaml")

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

sim |> 
  get_table_data("Daily", "Skipjack tuna Catches (kg)") |>
  plot()
```

More to come in the near future if all goes well.
