#!/usr/bin/env Rscript

if (is.null(pkgdown:::pkgdown_config_path("."))) {
  rlang::inform(paste0(
    "{pkgdown} seems not configured, the remainder of the check is skipped. ",
    "For this hook to not even be invoked, remove `id: pkgdown` from ",
    "`.pre-commit-config.yaml`."
  ))
  quit()
}

if (!require(pkgdown, quietly = TRUE)) {
  stop("{pkgdown} could not be loaded, please install it.")
}
if (packageVersion("pkgdown") < package_version("2.0.4")) {
  rlang::abort("You need at least version 2.0.4 of {pkgdown} to run this hook.")
}
check_pkgdown()
