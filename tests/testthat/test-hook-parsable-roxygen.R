# success - code not evaluated
run_test(
  "parsable-roxygen",
  suffix = "-success.R",
  std_out = NULL,
  std_err = NULL,
  read_only = TRUE
)

# success - code evaluated
run_test(
  "parsable-roxygen",
  suffix = "-success.R",
  cmd_args = "--eval",
  std_out = "A random print statement",
  std_err = NULL,
  read_only = TRUE
)

# failure - roxygen problem
run_test(
  "parsable-roxygen",
  suffix = "-fail.R",
  std_out = "Roxygen commentary",
  std_err = "@description has mismatched braces or quotes",
  read_only = TRUE
)

# failure - R problem
run_test(
  "parsable-roxygen",
  suffix = "-fail2.R",
  std_out = "File ",
  std_err = "unexpected '}'",
  read_only = TRUE
)
