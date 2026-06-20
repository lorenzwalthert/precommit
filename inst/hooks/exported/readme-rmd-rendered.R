
# Check for source files (case-insensitive)
rmd_files <- list.files(pattern = "^README\\.[Rr]md$")
qmd_files <- list.files(pattern = "^README\\.[Qq]md$")

if (length(rmd_files) + length(qmd_files) > 1) {
  rlang::abort("Multiple README source files found. Please use only one format (README.Rmd or README.qmd).")
}

# Determine which source file is present
if (length(rmd_files) == 1) {
  source_file <- rmd_files
} else if (length(qmd_files) == 1) {
  source_file <- qmd_files
} else {
  quit(status=0)
}

# Check if README.md exists and is in sync
if (file.exists("README.md")) {
  if (file.info("README.md")$mtime < file.info(source_file)$mtime) {
    rlang::abort(paste0("README.md is out of date; please re-knit ", source_file, "."))
  }
  
  if (!nzchar(Sys.which("git"))) {
    rlang::abort("git not found on `$PATH`, hook can't be run.")
  }
  
  # Get staged files
  file_names_staged <- system2(
    "git", c("diff --cached --name-only"),
    stdout = TRUE
  )
  
  # Check that both source and output are staged together
  source_staged <- source_file %in% file_names_staged
  output_staged <- "README.md" %in% file_names_staged
  
  if (!source_staged || !output_staged) {
    rlang::abort(paste(source_file, "and README.md must both be staged."))
  }
}
