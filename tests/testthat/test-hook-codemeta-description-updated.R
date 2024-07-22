run_test("codemeta-description-update",
  file_name = c("codemeta.json"),
  suffix = "",
  std_out = "No `DESCRIPTION` found in repository.",
  std_err = "",
  expect_success = FALSE,
  read_only = TRUE,
)

run_test("codemeta-description-update",
  file_name = c("DESCRIPTION"),
  suffix = "",
  std_out = "No `codemeta.json` found in repository.",
  std_err = "",
  # voluntary
  expect_success = FALSE,
  read_only = TRUE
)


# outdated
run_test("codemeta-description-update",
  file_name = c("DESCRIPTION", "codemeta.json"),
  suffix = "",
  std_err = "",
  expect_success = FALSE,
  std_out = "out of date",
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
