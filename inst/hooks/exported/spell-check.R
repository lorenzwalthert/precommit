#!/usr/bin/env Rscript

"Spell check for files
Usage:
  spell-check [--lang=<language>] [--read-only] <files>...

Options:
  --lang=<language> Passed to `spelling::spell_check_files()` [default: en_US]
  --read-only       Don't update inst/WORDLIST with errors (new words)

" -> doc

arguments <- precommit::precommit_docopt(doc)
path_wordlist <- file.path("inst", "WORDLIST")
files <- arguments$files
if (file.exists(path_wordlist)) {
  ignore <- readLines(path_wordlist, encoding = "UTF-8")
  action <- "update"
} else {
  if (isFALSE(arguments$read_only)) {
    if (!dir.exists(dirname(path_wordlist))) {
      dir.create(dirname(path_wordlist))
    }
    file.create(path_wordlist)
  }
  ignore <- character()
  action <- "create"
}


spelling_errors <- spelling::spell_check_files(
  files,
  ignore = ignore,
  lang = arguments$lang
)

if (nrow(spelling_errors) > 0) {
  cat("The following spelling errors were found:\n")
  print(spelling_errors)
  if (isTRUE(arguments$read_only)) {
    cat("Hint: you can enable an automatic updating of WORDLIST with errors (new words) by removing the --read-only flag.\n")
  } else {
    ignore_df <- data.frame(
      original = unique(c(ignore, spelling_errors$word))
    )
    ignore_df$lower <- tolower(ignore_df$original)
    ignore_df <- ignore_df[order(ignore_df$lower, method = "radix"), ]
    ignore <- ignore_df$original[ignore_df$lower != ""] # drop blanks if any
    writeLines(ignore, path_wordlist)
    cat(
      "All spelling errors found were copied to inst/WORDLIST assuming they were",
      "not spelling errors and will be ignored in the future. Please",
      "review the above list and for each word that is an actual typo:\n",
      "- fix it in the source code.\n",
      "- remove it again manually from inst/WORDLIST to make sure it's not\n",
      "  ignored in the future.\n",
      "Then, try committing again.\n",
      "Hint: you can disable this behavior by providing a --read-only flag.\n"
    )
  }
  stop("Spell check failed", call. = FALSE)
}
