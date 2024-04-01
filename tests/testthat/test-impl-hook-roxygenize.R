test_that("relevant diffs can be detected", {
  skip_on_cran()
  withr::with_tempdir({
    fs::dir_create("R")
    # when new lines are added
    text <- c("#' Roxygen comment", "#'", "#' more things", "NULL")
    writeLines(text, "R/first.R")
    writeLines(text, "R/second.R")
    git_init(".")
    expect_false(diff_requires_run_roxygenize("."))
    git2r::add(".", "R/first.R")
    git2r::status()

    expect_true(diff_requires_run_roxygenize("."))
    git2r::commit(".", "add roxgen2 file")

    # when non roxygen lines are added
    text2 <- c("if (x) {", " TRUE", "} else {", "  not_TRue(sinux(-i))", "}")
    writeLines(text2, "R/third.R")

    git2r::add(".", "R/third.R")
    expect_false(diff_requires_run_roxygenize("."))
    git2r::commit(".", "add non-roxygen2 file")

    # when roxygen line is replaced
    text[1] <- "# not roxygen, but replaced old "
    writeLines(text, "R/first.R")
    writeLines(text[1], "R/fourth.R")

    git2r::add(".", c("R/first.R", "R/fourth.R"))
    git2r::status()
    expect_true(diff_requires_run_roxygenize("."))
    git2r::commit(".", "replaced")


    # when roxygen line is removed
    writeLines("#", "R/first.R")

    git2r::add(".", "R/first.R")
    expect_true(diff_requires_run_roxygenize("."))
    git2r::commit(".", "when reomved")
  })
})

test_that("change in formals alone triggers invalidation", {
  skip_on_cran()
  # when the function formals change but nothing else
  withr::with_tempdir({
    fs::dir_create("R")
    git_init(".")
    # when new lines are added
    text <- c("#' Roxygen comment", "#'", "#' more things", "x <- function(a = 2) {", "  a", "}")
    writeLines(text, "R/fifth.R")
    expect_false(diff_requires_run_roxygenize("."))
    git2r::add(".", "R/fifth.R")

    expect_true(diff_requires_run_roxygenize("."))
    git2r::commit(".", "add file 5")
    # change signature
    text <- c("#' Roxygen comment", "#'", "#' more things", "x <- function(a = 3) {", "  a", "}")
    writeLines(text, "R/fifth.R")
    git2r::add(".", "R/fifth.R")
    git2r::commit(".", "clear case 5")
  })
})


test_that("asserting installed dependencies", {
  local_test_setup(git = FALSE, use_precommit = FALSE, package = TRUE)
  installed <- c("pkgload", "rlang", "testthat")
  purrr::walk(installed, usethis::use_package)
  writeLines(c("utils::adist", "rlang::is_installed"), "R/blur.R")
  testthat::expect_silent(roxygen_assert_additional_dependencies())
  writeLines(generate_uninstalled_pkg_call(), "R/core.R")
  testthat::expect_error(
    roxygen_assert_additional_dependencies(),
    "there is no package called"
  )
})

test_that("roxygenize works in general", {
  skip_on_cran()
  local_test_setup(git = FALSE, use_precommit = FALSE, package = TRUE)
  writeLines(c("#' This is a title", "#'", "#' More", "#' @name test", "NULL"), "R/blur.R")
  # works
  local_mocked_bindings(diff_requires_run_roxygenize = function(...) TRUE)
  expect_message(
    roxygenize_with_cache(list(getwd()), dirs = dirs_R.cache("roxygenize")),
    "test\\.Rd"
  )
})


test_that("fails when package is called but not installed in roclets", {
  skip_on_cran()
  local_test_setup(git = FALSE, use_precommit = FALSE, package = TRUE)
  writeLines(c("NULL"), "R/blur.R")
  # works
  local_mocked_bindings(diff_requires_run_roxygenize = function(...) TRUE)
  # when there is a missing package
  roxygen_field <- paste0(
    'list(markdown = TRUE, roclets = c("rd", "namespace", "collate", "',
    generate_uninstalled_pkg_call(), '"))'
  )
  desc::desc_set(Roxygen = roxygen_field)
  expect_error(
    roxygenize_with_cache(list(getwd()), dirs = dirs_R.cache("roxygenize")),
    "Please add the package as a dependency"
  )
})


test_that("fails gratefully when not installed package is called (packageNotFoundError)", {
  skip_on_cran()
  local_test_setup(git = FALSE, use_precommit = FALSE, package = TRUE)
  writeLines(generate_uninstalled_pkg_call(), "R/blur.R")
  # works
  local_mocked_bindings(diff_requires_run_roxygenize = function(...) TRUE)
  # when there is a missing package
  expect_error(
    roxygenize_with_cache(list(getwd()), dirs = dirs_R.cache("roxygenize")),
    "there is no package called"
  )
})

test_that("fails gratefully when not installed package is required according to `DESCRIPTION`", {
  skip_on_cran()
  local_test_setup(git = FALSE, use_precommit = FALSE, package = TRUE)
  desc::desc_set_deps(
    tibble::tibble(type = "Imports", package = generate_uninstalled_pkg_name(), version = "*")
  )
  local_mocked_bindings(diff_requires_run_roxygenize = function(...) TRUE)
  expect_error(
    suppressWarnings(
      roxygenize_with_cache(list(getwd()), dirs = dirs_R.cache("roxygenize"))
    ),
    "The package.*required"
  )
})


test_that("fails when there is invalid code", {
  skip_on_cran()
  local_test_setup(git = FALSE, use_precommit = FALSE, package = TRUE)
  local_mocked_bindings(diff_requires_run_roxygenize = function(...) TRUE)
  # when there is a missing package
  writeLines(c("invalid code stuff /3kj"), "R/more.R")
  expect_error(
    roxygenize_with_cache(list(getwd()), dirs = dirs_R.cache("roxygenize")),
    "[Uu]nexpected symbol"
  )
})

test_that("warns if there is any other warning", {
  skip_on_cran()
  local_test_setup(git = FALSE, use_precommit = FALSE, package = TRUE)
  local_mocked_bindings(diff_requires_run_roxygenize = function(...) TRUE)
  writeLines(
    c(
      "#' This is a title", "#'", "#' More", "#", "NULL"
    ),
    "R/blur.R"
  )

  expect_message(
    roxygenize_with_cache(list(getwd()), dirs = dirs_R.cache("roxygenize")),
    "(with|a) @name"
  )
})
