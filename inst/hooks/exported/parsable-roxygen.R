#!/usr/bin/env Rscript

"Check whether roxygen comments within files are valid
Usage:
  parsable-roxygen [--no-eval] <files>...

Options:
  --no-eval  Parse, but do not evaluate, file contents - this also suppresses evaluation of `@eval` tags

" -> doc

arguments <- precommit::precommit_docopt(doc)

out <- lapply(arguments$files, function(path) {
  tryCatch(
    # Capture any messages from roxygen2:::warn_roxy()
    msg <- capture.output(
      roxygen2::parse_file(
        path,
        env = if (isTRUE(arguments$no_eval)) {
          NULL
        } else {
          roxygen2::env_file(path)
        }
      ),
      type = "message"
    ),

    # In case we encounter a more general file parsing problem
    error = function(e) {
      cat(c("File ", path, " is not parsable. Full context:\n"))
      stop(conditionMessage(e), call. = FALSE)
    }
  )

  if (length(msg) > 0) {
    cat(c("Roxygen commentary in file ", path, " is not parsable. Full context:\n"))
    stop(paste0(msg, collapse = "\n"), call. = FALSE)
  }
})
