path_test_repo <- "tests/tets-repo"
fs::dir_create(path_test_repo)
path <- c(PATH = paste0(
  Sys.getenv("PATH"), ":", Sys.getenv("HOME"), "/.pre-commit-venv/bin"
))
# initialize
withr::with_dir(
  path_test_repo, {
    processx::run("curl", "https://pre-commit.com/install-local.py | python -")
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


# how to install on windows
# how to call system? pre-commit install.
