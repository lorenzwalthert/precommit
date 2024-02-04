#!/usr/bin/env Rscript

"A hook to make sure DESCRIPTION hasn’t been edited more recently than
codemeta.json.

Usage:
  codemeta-description-updated [--root=<root_>] <files>...

Options:
  --root=<root_>  Path relative to the git root that contains the R package
                  root [default: .].

" -> doc


arguments <- precommit::precommit_docopt(doc)
setwd(arguments$root)

# adapted from https://github.com/lorenzwalthert/precommit/blob/f4413cfe6282c84f7176160d06e1560860c8bd3d/inst/hooks/exported/readme-rmd-rendered
if (!file.exists("DESCRIPTION")) {
  rlang::abort("No `DESCRIPTION` found in repository.")
}

if (!file.exists("codemeta.json")) {
  rlang::abort("No `codemeta.json` found in repository.")
}


codemeta_outdated <- file.info("DESCRIPTION")$mtime > file.info("codemeta.json")$mtime
if (codemeta_outdated) {
  rlang::abort("codemeta.json is out of date; please re-run codemetar::write_codemeta().")
}
