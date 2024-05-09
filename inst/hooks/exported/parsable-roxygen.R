#!/usr/bin/env Rscript
files <- commandArgs(trailing = TRUE)

out <- lapply(files, function(path) {
  tryCatch(
    roxygen2::parse_file(path, env = NULL),
    warning = function(w) {
      cat(c("Roxygen commentary in file ", path, " is not parsable. Full context:\n"))
      stop(conditionMessage(w), call. = FALSE)
    },
    error = function(e) {
      cat(c("File ", path, " is not parsable. Full context:\n"))
      stop(conditionMessage(e), call. = FALSE)
    }
  )
})
