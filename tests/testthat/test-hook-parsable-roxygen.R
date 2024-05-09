run_test(
  "parsable-roxygen",
  suffix = "-success.R",
  std_err = NULL
)

# failure
run_test(
  "parsable-roxygen",
  suffix = "-fail.R",
  std_out = "Full context",
  std_err = "@description has mismatched braces or quotes"
)
