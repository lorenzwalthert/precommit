run_test("style-files",
         file_name = "style-files-cmd",
         suffix = "-success.R",
         cmd_args = c("--style_pkg=styler", "'--style_transformers=tidyverse_style(scope = \"none\")'")
)

run_test("style-files",
         file_name = "style-files-cmd",
         suffix = "-success.R",
         cmd_args = c("--style_pkg=styler", "--style_transformers='tidyverse_style(scope = \"none\")'")
)

run_test("style-files",
         file_name = "style-files-cmd",
         suffix = "-success.R",
         cmd_args = c("--style_pkg=styler", "--style_transformers='tidyverse_style(scope= \"none\")'")
)
