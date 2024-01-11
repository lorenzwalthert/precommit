source("renv/activate.R")

options(
  repos = c(RSPM = renv::lockfile_read()$R$Repositories$RSPM), # CRAN is not an option, always use PPM
  install.packages.check.source = "no", # don't check if source packages are available
  install.packages.compile.from.source = "never" # probably redundant with the above 'no': If source package is available, only use source if no code needs to be compiled (needs compilation flag on CRAN).
)
renv::install("jsonlite")
renv_deps <- names(jsonlite::read_json("renv.lock")$Packages)
renv::load()
renv::restore(prompt = FALSE)
can_be_updated <- renv::update(setdiff(renv_deps, "renv"), prompt = FALSE, check = FALSE)
renv::snapshot(packages = renv_deps, prompt = FALSE)
