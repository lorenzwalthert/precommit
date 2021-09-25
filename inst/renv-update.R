# also see corresponding files to update
hook_deps <- function(root) {
  out <- renv::dependencies("inst/hooks/exported/")$Package
  desc <- desc::desc()
  deps <- desc$get_deps()
  dont <- c(
    "yaml", "usethis", "withr", "rstudioapi", "precommit",
    "httr" # lintr -> httr  -> curl -> libcurl, but seems to give no erorr on
    # loading lintr, plus https://github.com/jimhester/lintr/issues/861
  )
  out <- c(out, "roxygen2", "spelling", "styler", "pkgload", "lintr", "knitr", "git2r", "digest", "desc")
  out <- setdiff(c(unique(c(out, deps[deps$type == "Imports", ]$package))), dont)
  out <- names(renv:::renv_package_dependencies(out))
  return(out)
}

options(renv.snapshot.filter = hook_deps)

renv::snapshot(type = "custom", prompt = FALSE)
# or renv::snapshot(packages = hook_deps(), prompt = FALSE)
