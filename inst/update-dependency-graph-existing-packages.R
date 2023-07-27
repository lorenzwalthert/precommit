hook_deps <- function(root) {
  out <- renv::dependencies("inst/hooks/exported/")$Package
  desc <- desc::desc()
  deps <- desc$get_deps()
  dont <- c(
    "yaml", "usethis", "withr", "rstudioapi", "precommit",
    "pkgdown",
    "httr"
  )
  out <- c(out, "docopt", "roxygen2", "spelling", "styler", "pkgload", "lintr", "knitr", "desc", "jsonvalidate")
  out <- setdiff(c(unique(c(out, deps[deps$type == "Imports", ]$package))), dont)
  out <- names(renv:::renv_package_dependencies(out))
  return(sort(out))
}

source("inst/update-renv-prepare.R")
source("renv/activate.R")
renv::restore()
options(renv.snapshot.filter = hook_deps)

# TODO snapshot looks up from which repo the packages were installed.
# Hence, setting the repo option only affects new installs. Solution:
# - manually replace cran with rspm in renv.lock
# - first activate renv, restore renv and then run this script
renv::snapshot(type = "custom", prompt = FALSE)
