# success
run_test("renv-lockfile-validate",
  file_name = "renv-success",
  suffix = ".lock", cmd_args = c("--error"),
  std_err = NULL
)
# fail
run_test("renv-lockfile-validate",
  file_name = "renv-fail",
  suffix = ".lock", cmd_args = c("--error"),
  std_err = "error validating json"
)
