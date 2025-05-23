test_that("snippet generation works for roxygen", {
  local_test_setup(
    git = FALSE, use_precommit = FALSE, package = TRUE, install_hooks = FALSE
  )
  usethis::use_package("R", "Depends", "3.6.0")
  expect_error(
    out <- capture_output(snippet_generate("additional-deps-roxygenize")),
    NA,
  )
  expect_equal(out, "")
  usethis::use_package("styler")
  expect_error(
    out <- capture_output(snippet_generate("additional-deps-roxygenize")),
    NA,
  )

  expect_match(
    out, "    -   id: roxygenize\n.*        -    styler\n$",
  )
  desc::desc_set("Remotes", "r-lib/styler")
  expect_warning(
    out <- capture_output(snippet_generate("additional-deps-roxygenize")),
    "you have remote dependencies "
  )
  expect_match(
    out, "    -   id: roxygenize\n.*        -    styler\n$",
  )
})


test_that("snippet generation works for lintr", {
  local_test_setup(
    git = FALSE, use_precommit = FALSE, package = TRUE, install_hooks = FALSE
  )
  usethis::use_package("R", "Depends", "3.6.0")
  expect_error(
    out <- capture_output(snippet_generate("additional-deps-lintr")),
    NA,
  )
  expect_equal(out, "")
  usethis::use_package("styler")
  expect_error(
    out <- capture_output(snippet_generate("additional-deps-lintr")),
    NA,
  )

  expect_match(
    out, "    -   id: lintr\n.*        -    styler\n$",
  )
  desc::desc_set("Remotes", "r-lib/styler")
  expect_warning(
    out <- capture_output(snippet_generate("additional-deps-roxygenize")),
    "you have remote dependencies "
  )
  expect_match(
    out, "    -   id: roxygenize\n.*        -    styler\n$",
  )
})

test_that("snippet generation only includes hard dependencies", {
  local_test_setup(
    git = FALSE, use_precommit = FALSE, package = TRUE,
    install_hooks = FALSE, open = FALSE
  )
  usethis::use_package("styler")
  usethis::use_package("lintr", type = "Suggest")
  expect_warning(
    out <- capture_output(snippet_generate("additional-deps-roxygenize")),
    NA
  )
  expect_match(
    out, "    -   id: roxygenize\n.*        -    styler\n$",
  )
})


test_that("GitHub Action CI setup works", {
  local_test_setup(
    git = FALSE, use_precommit = FALSE, package = TRUE, install_hooks = FALSE
  )
  use_precommit_config(
    root = getwd(),
    open = FALSE, verbose = FALSE
  )
  expect_error(use_ci("stuff", root = getwd()), "must be one of")
  use_ci("gha", root = getwd())
  expect_true(file_exists(".github/workflows/pre-commit.yaml"))
})

test_that("Pre-commit CI GitHub Action template is parsable", {
  expect_error(
    yaml::read_yaml(system.file("pre-commit-gha.yaml", package = "precommit")),
    NA
  )
})

test_that("Pre-commit CI setup works", {
  local_test_setup(
    git = FALSE, use_precommit = FALSE, package = TRUE, install_hooks = FALSE
  )
  use_precommit_config(
    root = getwd(),
    open = FALSE, verbose = FALSE
  )
  use_ci(root = getwd(), open = FALSE)
  expect_false(file_exists(".github/workflows/pre-commit.yaml"))
})

test_that("Pre-commit CI setup works", {
  local_test_setup(
    git = FALSE, use_precommit = FALSE, package = TRUE, install_hooks = FALSE
  )
  expect_error(use_ci(root = getwd(), open = FALSE), "o `.pre-commit-config.yaml`")
})
