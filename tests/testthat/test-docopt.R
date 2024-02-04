test_that("custom docopt interface parses as expected", {
  args_variants <- list(
    "file a.R",
    c("file a.R", "file-B.R"),
    c("File A.R", "File c.R"),
    c("Another file with spaces.R", "--warn_only"),
    c("Another file with spaces.R", "Yet another file with spaces (YAFWS).R", "--warn_only"),
    c("--warn_only", "Another file with spaces.R"),
    c("--warn_only", "Another file with spaces.R", "Yet another file with spaces (YAFWS).R"),
    c("Another file with spaces.R", "--warn_only", "Yet another file with spaces (YAFWS).R")
  )

  "Run lintr on R files during a precommit.
Usage:
  cmdtest [--warn_only] <files>...
Options:
  --warn_only  Placeholder for test.
" -> doc

  for (args in args_variants) {
    new_args <- precommit_docopt(doc, args)

    # to show failures in vanilla docopt, use this:
    # new_args <- docopt::docopt(doc, args)

    expect_equal(length(new_args), 4)
    if ("--warn_only" %in% args) {
      expect_equal(length(new_args$files), length(args) - 1)
      expect_equal(length(new_args$`<files>`), length(args) - 1)
      expect_true(new_args$warn_only)
      expect_true(new_args$`--warn_only`)
    } else {
      expect_equal(length(new_args$files), length(args))
      expect_equal(length(new_args$`<files>`), length(args))
      expect_false(new_args$warn_only)
      expect_false(new_args$`--warn_only`)
    }
  }
})
