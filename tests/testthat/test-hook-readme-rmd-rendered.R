if (has_git()) {
  run_test("readme-rmd-rendered",
    file_name = c("README.md", "README.Rmd"),
    suffix = "",
    std_err = "out of date",
    std_out = NULL,
    file_transformer = function(files) {
      if (length(files) > 1) {
        # transformer is called once on all files and once per file
        content_2 <- readLines(files[2])
        Sys.sleep(2)
        writeLines(content_2, files[2])
        git_init()
        git2r::add(path = files)
      }
      files
    }
  )


  # only one file staged
  run_test("readme-rmd-rendered",
    file_name = c("README.Rmd", "README.md"),
    suffix = "",
    std_err = "should be both staged",
    std_out = NULL,
    file_transformer = function(files) {
      if (length(files) > 1) {
        # transformer is called once on all files and once per file
        content_2 <- readLines(files[2])
        Sys.sleep(2)
        writeLines(content_2, files[2])
        git_init()
        git2r::add(path = files[1])
      }
      files
    }
  )

  # only has md
  run_test("readme-rmd-rendered",
    file_name = "README.md",
    suffix = "",
    std_err = NULL,
    std_out = NULL,
    file_transformer = function(files) {
      git_init()
      git2r::add(path = files[1])
      files
    }
  )

  # only has Rmd
  run_test("readme-rmd-rendered",
    file_name = "README.Rmd",
    suffix = "",
    std_err = NULL,
    std_out = NULL,
    file_transformer = function(files) {
      git_init()
      git2r::add(path = files[1])
      files
    }
  )
}
