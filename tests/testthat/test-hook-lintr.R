# .R ----

# success
run_test("lintr",
  suffix = "-success.R",
  std_err = NULL
)

# failure
run_test("lintr", suffix = "-fail.R", std_err = "not lint free")

if (!on_windows_on_cran()) {
  # warning
  run_test(
    "lintr",
    suffix = "-fail.R", cmd_args = "--warn_only", std_err = NULL
  )

  # .qmd ----

  # success
  run_test("lintr", suffix = "-success.qmd", std_err = NULL)

  # failure
  run_test("lintr", suffix = "-fail.qmd", std_err = "not lint free")
}
