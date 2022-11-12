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
if (!require(mockery, quietly = TRUE)) {
  stop("{mockery} could not be loaded, please install it.")
}

stub_render_page <- function(pkg, name, data, ...) {
  force(data)
}
stub(build_reference_index, "render_page", stub_render_page)
stub(build_articles_index, "render_page", stub_render_page)
config <- yaml::read_yaml(pkgdown:::pkgdown_config_path("."))

tryCatch(
  {
    if ("reference" %in% names(config)) {
      build_reference_index()
    }
    if ("articles" %in% names(config)) {
      build_articles_index()
    }
  },
  error = function(e) stop(e),
  warning = function(w) stop(w)
)
