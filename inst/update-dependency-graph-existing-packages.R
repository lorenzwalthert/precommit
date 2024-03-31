hook_deps <- function(root) {
  out <- renv::dependencies("inst/hooks/exported/")$Package
  desc <- desc::desc()
  deps <- desc$get_deps()
  dont <- c(
    "yaml", "usethis", "withr", "rstudioapi", "precommit",
    "pkgdown",
    "httr"
  )
  out <- c(out, "docopt", "roxygen2", "spelling", "styler", "pkgload", "lintr", "knitr", "desc")
  out <- setdiff(c(unique(c(out, deps[deps$type == "Imports", ]$package))), dont)
  out <- names(renv:::renv_package_dependencies(out))
  return(sort(out))
}

source("inst/update-renv-prepare.R")
source("renv/activate.R")
options(renv.snapshot.filter = hook_deps)

renv::snapshot(type = "custom", prompt = FALSE)
