#!/usr/bin/env Rscript

if (!require(pkgdown)) {
  stop("{pkgdown} could not be loaded.")
}
if (!require(mockery)) {
  stop("{mockery} could not be loaded.")
}

stub_render_page <- function(pkg, name, data, ...) {
  force(data)
}
stub(build_reference_index, "render_page", stub_render_page)
stub(build_articles_index, "render_page", stub_render_page)

tryCatch(
  {
    build_reference_index()
    build_articles_index()
  },
  error = function(e) e,
  warning = function(w) stop(w)
)
