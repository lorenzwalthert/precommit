#!/usr/bin/env Rscript

if (!require(readr, quietly = TRUE)) {
  stop("{readr} could not be loaded, please install it.")
}

if (!require(jsonvalidate, quietly = TRUE)) {
  stop("{jsonvalidate} could not be loaded, please install it.")
}

library(readr)
library(jsonvalidate)

files <- commandArgs(trailing = TRUE)
path_renv_schema <- file.path("inst", "renv.schema.json")
renv_schema <- readr::read_file(path_renv_schema)

validate_renv_lock <- function(renv_path, renv_lock_schema) {
  renv_json <- readr::read_file(renv_path)

  jsonvalidate::json_validate(
    renv_json,
    renv_lock_schema,
    engine  = "ajv",
    greedy  = TRUE,
    error   = TRUE,
    verbose = TRUE
  )
}

out <- lapply(files, function(path) {
  is_renv_lock <- grepl("^.*renv\\.lock$", path)
  if (is_renv_lock) {
    print(paste0(path, " is a renv.lock file"))
    tryCatch(
      validate_renv_lock(path, renv_schema),
      error = function(error) {
        cat(c("renv.lock at", path, "failed validation. Full context:\n"))
        stop(conditionMessage(error), call. = FALSE)
      }
    )
  }
})
