# success
run_test(
  "no-browser-statement",
  suffix = "-success.R",
  std_err = NULL
)

# failure
run_test(
  "no-browser-statement",
  suffix = "-fail.R",
  std_err = "contains a `browser()` statement."
)
