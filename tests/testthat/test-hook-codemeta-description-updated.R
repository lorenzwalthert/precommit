run_test("codemeta-description-update",
  file_name = c("codemeta.json"),
  suffix = "",
  std_err = "No `DESCRIPTION` found in repository.",
  std_out = NULL,
)

# succeed
run_test("codemeta-description-update",
  file_name = c("DESCRIPTION", "codemeta.json"),
  suffix = "",
  file_transformer = function(files) {
    if (length(files) > 1) {
      # transformer is called once on all files and once per file
      content_2 <- readLines(files[2])
      Sys.sleep(2)
      writeLines(content_2, files[2])
    }
    files
  }
)

if (!on_cran()) {
  # succeed in correct root
  run_test("codemeta-description-update",
    file_name = c(
      "rpkg/DESCRIPTION" = "DESCRIPTION",
      "rpkg/codemeta.json" = "codemeta.json"
    ),
    cmd_args = "--root=rpkg",
    suffix = "",
    file_transformer = function(files) {
      if (length(files) > 1) {
        # transformer is called once on all files and once per file
        content_2 <- readLines(files[2])
        Sys.sleep(2)
        writeLines(content_2, files[2])
      }
      files
    }
  )

  # # fail in wrong root
  run_test("codemeta-description-update",
    file_name = c(
      "rpkg/DESCRIPTION" = "DESCRIPTION",
      "rpkg/codemeta.json" = "codemeta.json",
      "rpkg2/codemeta.json" = "README.md"
    ),
    cmd_args = "--root=rpkg2",
    std_err = "No `DESCRIPTION` found in repository.",
    suffix = "",
    file_transformer = function(files) {
      if (length(files) > 1) {
        # transformer is called once on all files and once per file
        content_2 <- readLines(files[2])
        Sys.sleep(2)
        writeLines(content_2, files[2])
      }
      files
    }
  )
}

if (!on_windows_on_cran()) {
  run_test("codemeta-description-update",
    file_name = c("DESCRIPTION"),
    suffix = "",
    std_err = "No `codemeta.json` found in repository.",
    std_out = NULL,
  )


  # outdated
  run_test("codemeta-description-update",
    file_name = c("DESCRIPTION", "codemeta.json"),
    suffix = "",
    std_err = "out of date",
    std_out = NULL,
    file_transformer = function(files) {
      if (length(files) > 1) {
        # transformer is called once on all files and once per file
        content_2 <- readLines(files[1])
        Sys.sleep(2)
        writeLines(content_2, files[1])
      }
      files
    }
  )
}
