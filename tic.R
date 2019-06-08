get_stage("install") %>%
  add_code_step(remotes::install_deps(upgrade = FALSE, lib = .libPaths()[length(.libPaths())]))

get_stage("script") %>%
 add_code_step(source('tests/runner.R'))
