path_test_repo <- "tests/test-repo"
fs::dir_create(path_test_repo)
path <- c(PATH = paste0(
  Sys.getenv("PATH"), ":", Sys.getenv("HOME"), "/.pre-commit-venv/bin"
))
repo <- git2r::init(path_test_repo)
git2r::config(repo, user.name = "ci", user.email = "example@example.com")

if (length(.libPaths()) > 1) {
  path_r_prof <- fs::path(Sys.getenv("HOME"), ".Rprofile")
  print("libpats are")
  print(.libPaths())
  print("writing this to .Rprofile")
  to_r_prof <- paste0(".libPaths('", .libPaths(), "')")
  cat(to_r_prof)
  writeLines(to_r_prof, path_r_prof) 
  cat(readLines(path_r_prof))
  print("echo $R_PROFILE_USER")
  system2("echo", "$R_PROFILE_USER")
  print("echo $R_LIBS")
  system2("echo", "$R_LIBS")
  print("echo $R_LIBS_USER")
  system2("echo", "$R_LIBS_USER")
  print("path home")
  system2("echo", "$HOME")
  print("global rprof")
  system2("cat", "$HOME/.Rprofile")
  print("project rprof")
  system2("cat", ".Rprofile")
}


# initialize
withr::with_dir(
  path_test_repo, {
    # can't use processx::run() because of pipe
    system2("curl", "https://pre-commit.com/install-local.py | python -")
    writeLines(c(
      "-   repo: https://github.com/lorenzwalthert/pre-commit-hooks",
      "    rev: 6d760ddc9843c46e93550d0e0db0a12c2a97432a",
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
  processx::run("git", c("commit", "-m", "shall pass"), env = path, echo = TRUE, echo_cmd = TRUE)
})
