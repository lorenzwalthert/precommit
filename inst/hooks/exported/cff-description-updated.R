#!/usr/bin/env Rscript

"A hook to make sure DESCRIPTION hasn't been edited more recently than
CITATION.cff.

Usage:
  cff-description-updated [--root=<root_>] <files>...

Options:
  --root=<root_>  Path relative to the git root that contains the R package
                  root [default: .].

" -> doc


arguments <- docopt::docopt(doc)
setwd(arguments$root)

# adapted from https://github.com/lorenzwalthert/precommit/blob/d2dcd45f30b6c52469665c89cb7cba53e716a62a/inst/hooks/exported/codemeta-description-updated.R
if (!file.exists("DESCRIPTION")) {
  rlang::abort("No `DESCRIPTION` found in repository.")
}

if (!file.exists("CITATION.cff")) {
  rlang::abort("No `CITATION.cff` found in repository.")
}


codemeta_outdated <- file.info("DESCRIPTION")$mtime > file.info("CITATION.cff")$mtime
if (codemeta_outdated) {
  rlang::abort("CITATION.cff is out of date; please re-run cffr::cff_write().")
}
