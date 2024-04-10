# with outdated Rd present
run_test("roxygenize",
  file_name = c("man/flie.Rd" = "flie.Rd"),
  suffix = "",
  std_err = NA,
  std_out = empty_on_cran("Writing NAMESPACE"),
  artifacts = c(
    "DESCRIPTION" = test_path("in/DESCRIPTION-no-deps.dcf"),
    "R/roxygenize.R" = test_path("in/roxygenize.R")
  ),
  file_transformer = function(files) {
    git_init()
    git2r::add(path = files)
    # hack to add artifact to trigger diff_requires_roxygenize()
    git2r::add(path = fs::path(fs::path_dir(fs::path_dir(files[1])), "R"))
    files
  }
)

if (!on_cran()) {
  # with outdated Rd present in correct root
  run_test("roxygenize",
    file_name = c("rpkg/man/flie.Rd" = "flie.Rd"),
    suffix = "",
    std_err = NA,
    cmd_args = "--root=rpkg",
    std_out = empty_on_cran("Writing NAMESPACE"),
    artifacts = c(
      "rpkg/DESCRIPTION" = test_path("in/DESCRIPTION-no-deps.dcf"),
      "rpkg/R/roxygenize.R" = test_path("in/roxygenize.R")
    ),
    file_transformer = function(files) {
      withr::local_dir("rpkg")
      git_init()
      git2r::add(path = files)
      # hack to add artifact to trigger diff_requires_roxygenize()
      git2r::add(path = fs::path(fs::path_dir(fs::path_dir(files[1])), "R"))
      files
    }
  )
  # without Rd present
  run_test("roxygenize",
    file_name = c("rpkg1/R/roxygenize.R" = "roxygenize.R"),
    suffix = "",
    cmd_args = "--root=rpkg1",
    std_err = "Please commit the new `.Rd` files",
    artifacts = c(
      "rpkg1/DESCRIPTION" = test_path("in/DESCRIPTION-no-deps.dcf"),
      "rpkg2/R/roxygenize.R" = test_path("in/roxygenize.R")
    ),
    file_transformer = function(files) {
      withr::local_dir("rpkg1")
      git_init()
      git2r::add(path = files)
      files
    }
  )
}



# with Rd present in wrong root
run_test("roxygenize",
  file_name = c("R/roxygenize.R" = "roxygenize.R"),
  suffix = "",
  std_err = "Please commit the new `.Rd` files",
  artifacts = c(
    "DESCRIPTION" = test_path("in/DESCRIPTION-no-deps.dcf")
  ),
  file_transformer = function(files) {
    git_init()
    git2r::add(path = files)
    files
  }
)


# with up to date rd present
run_test("roxygenize",
  file_name = c("man/flie.Rd" = "flie-true.Rd"),
  suffix = "",
  std_err = empty_on_cran("Writing NAMESPACE"),
  artifacts = c(
    "DESCRIPTION" = test_path("in/DESCRIPTION-no-deps.dcf"),
    "R/roxygenize.R" = test_path("in/roxygenize.R")
  ),
  file_transformer = function(files) {
    git_init()
    git2r::add(path = files)
    # hack to add artifact to trigger diff_requires_roxygenize()
    git2r::add(path = fs::path(fs::path_dir(fs::path_dir(files[1])), "R"))
    files
  },
  expect_success = TRUE
)
