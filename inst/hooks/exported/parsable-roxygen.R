#!/usr/bin/env Rscript
files <- commandArgs(trailing = TRUE)

out <- lapply(files, function(path) {
  
  tryCatch(
    # Capture any messages from roxygen2:::warn_roxy()
    msg <- capture.output(
      roxygen2::parse_file(path, env = NULL),
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
