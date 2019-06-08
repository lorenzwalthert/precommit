path_test_repo <- "tests/test-repo"
fs::dir_create(path_test_repo)
path <- c(PATH = paste0(
  Sys.getenv("PATH"), ":", Sys.getenv("HOME"), "/.pre-commit-venv/bin"
))
repo <- git2r::init(path_test_repo)
git2r::config(repo, user.name = "ci", user.email = "example@example.com")


# initialize
withr::with_dir(
  path_test_repo, {
    # can't use processx::run() because of pipe
    system2("curl", "https://pre-commit.com/install-local.py | python -")
    writeLines(c(
      "-   repo: https://github.com/lorenzwalthert/pre-commit-hooks",
      "    rev: latest",
      "    hooks:",
      "    - id: devtools-document",
      "    - id: styler-style-files",
      "    - id: usethis-use-tidy-description"
    ), ".pre-commit-config.yaml")
    processx::run("pre-commit", "install",
      env = path
    )
  }
)

# hooks are not supported in git2r: https://github.com/ropensci/git2r/issues/118
fs::file_copy(fs::dir_ls("resources"), path_test_repo)
withr::with_dir(path_test_repo, {
  git2r::add(repo, "styler-style-files-positive.R")
  processx::run("git", c("commit", "-m", "shall pass"), env = path)
})
