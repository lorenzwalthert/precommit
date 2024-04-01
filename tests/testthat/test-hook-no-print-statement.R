# success
run_test(
  "no-print-statement",
  suffix = "-success.R",
  std_err = NULL
)

# failure
run_test(
  "no-print-statement",
  suffix = "-fail.R",
  std_err = "contains a `print()` statement."
)
