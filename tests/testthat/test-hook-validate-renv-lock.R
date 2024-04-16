# success
run_test(
  "validate-renv-lock",
  file_name = c("validate-renv-lock"),
  suffix = "-success.lock"
)

# failure
run_test(
  "validate-renv-lock",
  file_name = c("validate-renv-lock"),
  suffix = "-fail.lock"
)
