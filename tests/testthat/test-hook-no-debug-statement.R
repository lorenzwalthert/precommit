# success
run_test(
  "no-debug-statement",
  suffix = "-success.R",
  std_err = NULL
)

# failure
run_test(
  "no-debug-statement",
  suffix = "-fail.R",
  std_err = "contains a `debug()` or `debugonce()` statement."
)
