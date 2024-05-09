run_test(
  "parsable-roxygen",
  suffix = "-success.R",
  std_err = NULL
)

# failure - roxygen not parsed
run_test(
  "parsable-roxygen",
  suffix = "-fail.R",
  std_out = "Roxygen commentary",
  std_err = "@description has mismatched braces or quotes"
)

# failure - R not parsed
run_test(
  "parsable-roxygen",
  suffix = "-fail2.R",
  std_out = "File ",
  std_err = "unexpected '}'"
)
