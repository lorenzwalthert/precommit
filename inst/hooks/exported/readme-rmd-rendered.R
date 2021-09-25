if (!file.exists("README.Rmd") | !file.exists("README.md")) {
  return()
}

if (file.info("README.md")$ctime < file.info("README.Rmd")$ctime) {
  rlang::abort("README.md is out of date; please re-knit README.Rmd.")
}

num_readmes <- system2(
  "git",
  c("diff", "--cached", "--name-only", "|", "grep", "-Eic", "'^README\\.[R]?md$'")
)

if (num_readmes < 2) {
  rlang::abort("README.Rmd and README.md should be both staged.")
}
