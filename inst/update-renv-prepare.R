# emulate renv::lockfile_read()$R$Repositories$RSPM, which is not available on previous version of renv

options(
  repos = c(RSPM = {
    all_repos <- jsonlite::read_json("renv.lock")$R$Repositories
    all_repos[sapply(all_repos, \(x) x$Name == "RSPM")][[1]]$URL
  }), # CRAN is not an option, always use PPM
  install.packages.check.source = "no", # don't check if source packages are available
  install.packages.compile.from.source = "never" # probably redundant with the above 'no': If source package is available, only use source if no code needs to be compiled (needs compilation flag on CRAN).
)
