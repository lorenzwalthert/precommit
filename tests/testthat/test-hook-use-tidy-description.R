# success
run_test("use-tidy-description", "DESCRIPTION", suffix = "")



if (!on_cran()) {
  # in sub directory with correct root
  run_test("use-tidy-description",
    "DESCRIPTION",
    suffix = "",
    cmd_args = "--root=rpkg",
    artifacts = c("rpkg/DESCRIPTION" = test_path("in/DESCRIPTION"))
  )
  # in sub directory with incorrect root
  # Need to generate the directoy `rpkg` but without DESCRIPTION file.
  run_test("use-tidy-description",
    "DESCRIPTION",
    suffix = "",
    cmd_args = "--root=rpkg",
    std_err = "No `DESCRIPTION` found in repository.",
    artifacts = c("rpkg/README.md" = test_path("in/README.md"))
  )
}
