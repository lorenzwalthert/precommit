# success index
run_test("pkgdown",
  file_name = c(
    "man/autoudpate.Rd" = "autoupdate.Rd",
    "_pkgdown.yml" = "_pkgdown-index.yml",
    "DESCRIPTION" = "DESCRIPTION"
  ),
  suffix = "", std_err = NULL
)

# failed index
run_test("pkgdown",
  file_name = c(
    "man/flie-true.Rd" = "flie-true.Rd",
    "_pkgdown.yml" = "_pkgdown-index.yml",
    "DESCRIPTION" = "DESCRIPTION"
  ),
  suffix = "",
  std_err = "topic must be a known"
)

# failed articles
run_test("pkgdown",
  file_name = c(
    "vignettes/pkgdown.Rmd" = "pkgdown.Rmd",
    "_pkgdown.yml" = "_pkgdown-articles.yml",
    "DESCRIPTION" = "DESCRIPTION"
  ),
  suffix = "",
  std_err = "why-use-hooks"
)

# success index and article
run_test("pkgdown",
  file_name = c(
    "man/autoudpate.Rd" = "autoupdate.Rd",
    "vignettes/pkgdown.Rmd" = "pkgdown.Rmd",
    "_pkgdown.yml" = "_pkgdown-index-articles.yml",
    "DESCRIPTION" = "DESCRIPTION"
  ),
  suffix = "",
  std_err = NULL
)
