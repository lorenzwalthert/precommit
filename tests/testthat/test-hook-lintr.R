# success
run_test("lintr",
  suffix = "-success.R",
  std_err = NULL
)

# failure
run_test("lintr", suffix = "-fail.R", std_err = "not lint free")

# warning
run_test(
  "lintr",
  suffix = "-fail.R", cmd_args = "--warn_only", std_err = NULL
)
