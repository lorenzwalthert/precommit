#!/usr/bin/env Rscript


"Run lintr on R files during a precommit.
Usage:
  lintr [--warn_only] [--exclude_lintr=<linter1,linter2>] <files>...
Options:
  --warn_only  Print lint warnings instead of blocking the commit. Should be
               used with `verbose: True` in `.pre-commit-config.yaml`.
               Otherwise, lints will never be shown to the user.
  --exclude_lintr linters to exclude. Should be a comma-separated entry, e.g.
                  --exclude_lintr=object_name_linter,object_usage_linter
" -> doc

arguments <- docopt::docopt(doc)

lintr_staged <- grepl(
  "modified:.*\\.lintr", system2("git", "status", stdout = TRUE)
)
if (any(lintr_staged)) {
  stop(
    "Unstaged changes to .lintr file. Stage the .lintr file or discard ",
    "the changes to it. ",
    call. = FALSE
  )
}

exclude_linters <- trimws(strsplit(arguments$exclude_lintr, ",")[[1]])
n_exclude <- length(exclude_linters)
exclude_linters <- setNames(rep(list(NULL), n_exclude), exclude_linters)
default_linters <- do.call(lintr::linters_with_defaults, exclude_linters)

for (path in arguments$files) {
  lints <- lintr::lint(path, linters = default_linters)
  if (length(lints) > 0) {
    cat("File `", path, "` is not lint free\n", sep = "")
    rendered_lints <- capture.output(print(lints))
    cat(rendered_lints, sep = "\n")
    if (!arguments$warn_only) {
      stop("File ", path, " is not lint free", call. = FALSE)
    }
  }
}
