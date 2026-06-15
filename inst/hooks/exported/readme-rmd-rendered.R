renderable_files <- list.files(pattern = "^README\\.[QqRr]md$")
renderable <- ""
rmd <- grep("readme\\.rmd", renderable_files, ignore.case = TRUE, value = TRUE)
qmd <- grep("readme\\.qmd", renderable_files, ignore.case = TRUE, value = TRUE)

if (length(rmd) > 0) {
  if (length(qmd) > 0) {
    warning(paste0("Both ", rmd, " and ", qmd, " exist; ignoring ", qmd, "."))
  }
  renderable <- rmd[1]
} else {
  renderable <- qmd[1]
}

if (file.exists(renderable) && file.exists("README.md")) {
  if (file.info("README.md")$mtime < file.info(renderable)$mtime) {
    rlang::abort(paste0("README.md is out of date; please re-knit ", renderable, "."))
  }
  if (!nzchar(Sys.which("git"))) {
    rlang::abort("git not found on `$PATH`, hook can't be run.")
  }
  file_names_staged <- system2(
    "git", c("diff --cached --name-only"),
    stdout = TRUE
  )
  # num_readmes <- length(grepl("^README\\.[R]?md$", file_names_staged))
  staged_readmes <- grep("^README\\.[RrQq]?md$", file_names_staged, value = TRUE)
  if (length(staged_readmes) > 0) {
    rendered_staged <- any(grepl("README.md", staged_readmes, fixed = TRUE))
    renderable_staged <- any(grepl(renderable, staged_readmes, fixed = TRUE))

    if (!(rendered_staged && renderable_staged)) {
      rlang::abort(paste(renderable, "and README.md should be both staged."))
    }
  }
}
