source("inst/update-renv-prepare.R")
renv_deps <- names(jsonlite::read_json("renv.lock")$Packages)
source("renv/activate.R")
renv::load()
renv::restore(prompt = FALSE)
can_be_updated <- renv::update(setdiff(renv_deps, "renv"), prompt = FALSE, check = FALSE)
renv::snapshot(packages = renv_deps, prompt = FALSE)
