#!/usr/bin/env Rscript

files <- commandArgs(trailing = TRUE)
no_print_statement <- function(path) {
  pd <- getParseData(parse(path, keep.source = TRUE))
  if (any(pd$text[pd$token == "SYMBOL_FUNCTION_CALL"] == "print")) {
    stop("File `", path, "` contains a `print()` statement.", call. = FALSE)
  }
}

for (file in files) {
  temp <- no_print_statement(file)
}
