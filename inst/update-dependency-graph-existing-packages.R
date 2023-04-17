hook_deps <- function(root) {
  out <- renv::dependencies("inst/hooks/exported/")$Package
  desc <- desc::desc()
  deps <- desc$get_deps()
  dont <- c(
    "yaml", "usethis", "withr", "rstudioapi", "precommit",
    "pkgdown", "mockery",
    "httr"
  )
  out <- c(out, "roxygen2", "spelling", "styler", "pkgload", "lintr", "knitr", "git2r", "desc", "mockery")
  out <- setdiff(c(unique(c(out, deps[deps$type == "Imports", ]$package))), dont)
  out <- names(renv:::renv_package_dependencies(out))
  return(sort(out))
}
options(repos = c(CRAN = "https://packagemanager.rstudio.com/all/latest"))
options(renv.snapshot.filter = hook_deps)

renv::snapshot(type = "custom", prompt = FALSE)
