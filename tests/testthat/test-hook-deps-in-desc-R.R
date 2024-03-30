# succeed (call to library that is in description)
run_test("deps-in-desc",
  suffix = "-success.R", std_err = NULL,
  artifacts = c("DESCRIPTION" = test_path("in/DESCRIPTION"))
)

# fail (call to library that is not in description)
run_test("deps-in-desc",
  suffix = "-fail.R", std_err = "Dependency check failed",
  artifacts = c("DESCRIPTION" = test_path("in/DESCRIPTION"))
)

# in sub directory with wrong root
run_test("deps-in-desc",
  suffix = "-fail.R", std_err = "Could not find R package",
  file_transformer = function(files) {
    fs::path_abs(fs::file_move(files, "rpkg"))
  },
  artifacts = c("rpkg/DESCRIPTION" = test_path("in/DESCRIPTION"))
)

# in sub directory with correct root
if (!on_cran()) {
  run_test("deps-in-desc",
    cmd_args = "--root=rpkg",
    suffix = "-fail.R", std_err = "Dependency check failed",
    file_transformer = function(files) {
      fs::path_abs(fs::file_move(files, "rpkg"))
    },
    artifacts = c("rpkg/DESCRIPTION" = test_path("in/DESCRIPTION"))
  )
  # in sub directory with correct root
  run_test("deps-in-desc",
    cmd_args = "--root=rpkg",
    suffix = "-success.R", std_err = NULL,
    file_transformer = function(files) {
      fs::path_abs(fs::file_move(files, "rpkg"))
    },
    artifacts = c("rpkg/DESCRIPTION" = test_path("in/DESCRIPTION"))
  )
}


# with :::
run_test("deps-in-desc",
  "deps-in-desc-dot3",
  suffix = "-fail.R", std_err = "Dependency check failed",
  artifacts = c("DESCRIPTION" = test_path("in/DESCRIPTION"))
)

run_test("deps-in-desc",
  "deps-in-desc-dot3",
  suffix = "-success.R", std_err = NULL,
  artifacts = c("DESCRIPTION" = test_path("in/DESCRIPTION"))
)

run_test("deps-in-desc",
  "deps-in-desc-dot3",
  suffix = "-fail.R", std_err = NULL,
  artifacts = c("DESCRIPTION" = test_path("in/DESCRIPTION")),
  cmd_args = "--allow_private_imports"
)

# Rmd
run_test("deps-in-desc",
  "deps-in-desc",
  suffix = "-fail.Rmd", std_err = "Dependency check failed",
  std_out = "deps-in-desc-fail.Rmd`: ttyzp",
  artifacts = c("DESCRIPTION" = test_path("in/DESCRIPTION"))
)

run_test("deps-in-desc",
  "deps-in-desc",
  suffix = "-success.Rmd", std_err = NULL,
  artifacts = c("DESCRIPTION" = test_path("in/DESCRIPTION"))
)

# README.Rmd is excluded
run_test("deps-in-desc",
  "README.Rmd",
  suffix = "", std_err = NULL,
  artifacts = c("DESCRIPTION" = test_path("in/DESCRIPTION-no-deps.dcf"))
)



# Rnw
run_test("deps-in-desc",
  "deps-in-desc",
  suffix = "-fail.Rnw", std_err = "Dependency check failed",
  artifacts = c("DESCRIPTION" = test_path("in/DESCRIPTION"))
)

run_test("deps-in-desc",
  "deps-in-desc",
  suffix = "-success.Rnw", std_err = NULL,
  artifacts = c("DESCRIPTION" = test_path("in/DESCRIPTION"))
)

# Rprofile
# because .Rprofile is executed on startup, this must be an installed
# package (to not give an error staight away) not listed in
# test_path("in/DESCRIPTION")
if (Sys.getenv("GITHUB_WORKFLOW") != "Hook tests") {
  # seems like .Rprofile with renv activation does not get executed when
  # argument to Rscript contains Rprofile ?! Skip this
  expect_true(rlang::is_installed("R.cache"))
  run_test("deps-in-desc",
    "Rprofile",
    suffix = "", std_err = "Dependency check failed",
    artifacts = c("DESCRIPTION" = test_path("in/DESCRIPTION")),
    file_transformer = function(files) {
      writeLines("R.cache::findCache", files)
      fs::file_move(
        files,
        fs::path(fs::path_dir(files), paste0(".", fs::path_file(files)))
      )
    }
  )

  run_test("deps-in-desc",
    "Rprofile",
    suffix = "", std_err = NULL,
    artifacts = c("DESCRIPTION" = test_path("in/DESCRIPTION")),
    file_transformer = function(files) {
      writeLines("utils::head", files)
      fs::file_move(
        files,
        fs::path(fs::path_dir(files), paste0(".", fs::path_file(files)))
      )
    }
  )
}
