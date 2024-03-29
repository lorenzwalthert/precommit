# success
run_test("spell-check", suffix = "-success.md", std_err = NULL)

# failure with --read-only does not create WORDLIST
run_test(
  "spell-check",
  suffix = "-fail.md",
  std_err = "Spell check failed",
  cmd_args = "--read-only",
  read_only = TRUE
)

# failure with --read-only does not update WORDLIST
run_test(
  "spell-check",
  suffix = "-fail-2.md",
  std_err = "Spell check failed",
  cmd_args = "--read-only",
  artifacts = c("inst/WORDLIST" = test_path("in/WORDLIST")),
  read_only = TRUE
)

# success with wordlist
run_test("spell-check",
  suffix = "-wordlist-success.md",
  std_err = NULL,
  artifacts = c("inst/WORDLIST" = test_path("in/WORDLIST"))
)

# success with ignored files
# uses lang argument
run_test("spell-check", suffix = "-language-success.md", cmd_args = "--lang=en_GB")
