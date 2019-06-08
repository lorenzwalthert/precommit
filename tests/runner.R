path_test_repo <- "tests/tets-repo"
fs::dir_create(path_test_repo)

# initialize
withr::with_dir(
  path_test_repo, {
    git2r::init()
    processx::run("curl", "https://pre-commit.com/install-local.py | python -")
    writeLines(c(
      "-   repo: https://github.com/lorenzwalthert/pre-commit-hooks",
      "    rev: latest",
      "    hooks:",
      "    - id: devtools-document",
      "    - id: styler-style-files",
      "    - id: usethis-use-tidy-description"
    ), fs::path(path_test_repo, ".pre-commit-config.yaml"))
    #Sys.setenv(PATH = paste0(Sys.getenv("PATH"), ":/Users/lorenz/.pre-commit-venv/bin"))
    # system("pwd && pre-commit install -f")
  }
)


# how to install on windows
# how to call system? pre-commit install.