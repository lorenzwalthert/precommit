run_test("parsable-R",
  suffix = "-success.R",
  std_err = NULL
)
# failure
run_test("parsable-R", suffix = "-fail.R", std_out = "Full context", std_err = "1 1")

if (!on_windows_on_cran()) {
  run_test("parsable-R",
    suffix = "-success.Rmd",
    std_err = NULL
  )

  run_test(
    "parsable-R",
    suffix = "-fail.Rmd",
    std_out = "parsable-R-fail.Rmd",
    std_err = "1 1"
  )
}
