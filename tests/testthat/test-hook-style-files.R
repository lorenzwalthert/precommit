# success
run_test("style-files",
  suffix = "-success.R", cmd_args = c("--cache-root=styler")
)
# fail
run_test("style-files",
  suffix = "-fail-changed.R", cmd_args = c("--cache-root=styler"),
  std_err = NA
)


if (!on_windows_on_cran()) {
  run_test("style-files",
    suffix = "-fail-parse.R", cmd_args = c("--cache-root=styler"),
    std_err = ""
  )

  # success with cmd args
  run_test("style-files",
    file_name = "style-files-cmd",
    suffix = "-success.R",
    cmd_args = c("--style_pkg=styler", "--style_fun=tidyverse_style", "--cache-root=styler")
  )

  run_test("style-files",
    file_name = "style-files-cmd",
    suffix = "-success.R",
    cmd_args = c("--scope=spaces", "--cache-root=styler")
  )

  run_test("style-files",
    file_name = "style-files-cmd",
    suffix = "-success.R",
    cmd_args = c('--scope="I(\'spaces\')"', "--cache-root=styler")
  )

  run_test("style-files",
    file_name = "style-files-cmd",
    suffix = "-success.R",
    cmd_args = c(
      '--scope="I(\'spaces\')"',
      "--base_indention=0",
      "--include_roxygen_examples=TRUE",
      "--cache-root=styler"
    )
  )

  run_test("style-files",
    file_name = "style-files-reindention",
    suffix = "-success.R",
    cmd_args = c(
      '--scope="I(\'spaces\')"',
      "--base_indention=0",
      "--include_roxygen_examples=TRUE",
      '--reindention="specify_reindention(\'#\')"',
      "--cache-root=styler"
    )
  )

  run_test("style-files",
    file_name = "style-files",
    suffix = "-base-indention-success.R",
    cmd_args = c("--base_indention=4", "--cache-root=styler")
  )

  run_test("style-files",
    file_name = "style-files",
    suffix = "-roxygen-success.R",
    cmd_args = c("--include_roxygen_examples=FALSE", "--cache-root=styler")
  )

  run_test("style-files",
    file_name = "style-files",
    suffix = "-ignore-success.R",
    cmd_args = c(
      "--cache-root=styler",
      '--ignore-start="^# styler: off$"',
      '--ignore-stop="^# styler: on$"'
    )
  )

  run_test("style-files",
    file_name = "style-files",
    suffix = "-ignore-fail.R",
    cmd_args = "--cache-root=styler",
    std_err = ""
  )


  # fail with cmd args
  run_test("style-files",
    file_name = "style-files-cmd",
    suffix = "-success.R",
    cmd_args = c("--scope=space", "--cache-root=styler"),
    std_err = "",
    expect_success = FALSE
  )

  run_test("style-files",
    file_name = "style-files-cmd",
    suffix = "-fail.R",
    std_err = NA,
    cmd_args = c(
      "--style_pkg=styler", "--style_fun=tidyverse_style", "--cache-root=styler"
    )
  )

  run_test("style-files",
    file_name = "style-files-cmd",
    suffix = "-fail.R",
    std_err = "must be listed in `additional_dependencies:`",
    cmd_args = c(
      "--style_pkg=blubliblax", "--style_fun=tidyverse_style", "--cache-root=styler"
    )
  )
}
