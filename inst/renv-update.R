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
  out <- setdiff(c(unique(c(out, deps[deps$type == "Imports", ]$package))), dont)
  return(out)
}
options(renv.snapshot.filter = hook_deps)

renv::activate()
renv::snapshot(type = "custom")
renv::snapshot(packages = hook_deps())


#' * Run failed because of system dependencies for compiling packgages (matrix).
#'   This can be resolved by dropping --without-recommend-packages
#' * other packages will fail too because of system dependencies, in particular
#'   the roxygen hook needs gert -> libgit2, but apparently shipped binary.
#' * roxygen2 hook in addition needs to load the package,
#'   which means everyone who develops packages that depend on system
#'   dependencies won't manage install things.
#' * pak can help installing system dependencies but not sure they can persist
#'   the cache.


# -> hard dependencies: what the user needs
