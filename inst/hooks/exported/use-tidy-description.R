#!/usr/bin/env Rscript

"A hook to run usethis::use_tidy_description() to ensure dependencies are
ordered alphabetically and fields are in standard order.

Usage:
  use-tidy-description [--root=<root_>] <files>...

Options:
  --root=<root_>  Path relative to the git root that contains the R package root [default: .].

" -> doc


arguments <- precommit::precommit_docopt(doc)
setwd(arguments$root)

if (!file.exists("DESCRIPTION")) {
  rlang::abort("No `DESCRIPTION` found in repository.")
}

description <- desc::description$new()
description_old <- description$clone(deep = TRUE)
deps <- description$get_deps()
deps <- deps[order(deps$type, deps$package), , drop = FALSE]
description$del_deps()
description$set_deps(deps)
remotes <- description$get_remotes()
if (length(remotes) > 0) {
  description$set_remotes(sort(remotes))
}
description$set(Encoding = "UTF-8")
try(description$normalize(), silent = TRUE)
if (!all(capture.output(description) == capture.output(description_old))) {
  description$write()
}
