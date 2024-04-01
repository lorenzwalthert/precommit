test_that("Path can be derived for windows Python >= 3.0 (mocked)", {
  local_mocked_bindings(
    path_derive_precommit_exec_win_python3plus_candidates = function() {
      c(
        fs::path_home("AppData/Roaming/Python/Python35"),
        fs::path_home("AppData/Roaming/Python/Python37")
      )
    }
  )

  expect_equal(
    path_derive_precommit_exec_win_python3plus_base(),
    c(
      fs::path(fs::path_home(), "AppData/Roaming/Python/Python37/Scripts"),
      fs::path(fs::path_home(), "AppData/Roaming/Python/Python35/Scripts")
    ),
    ignore_attr = TRUE
  )
})


test_that("Path can be derived for windows Python >= 3.0 (actual)", {
  skip_if(!is_windows())
  skip_if(!not_conda())
  skip_if(on_cran())
  expect_match(path_derive_precommit_exec_win_python3plus_base(), "AppData/Roaming")
  expect_equal(
    fs::path_file(path_derive_precommit_exec_win()),
    precommit_executable_file()
  )
})


test_that("Warns when there are multiple installations found (2x os)", {
  local_mocked_bindings(
    path_derive_precommit_exec_path = function(candidate) {
      fs::path_home("AppData/Roaming/Python/Python35")
    },
    get_os = function(...) {
      c(sysname = "windows")
    },
    path_derive_precommit_exec_win = function() {
      c(
        fs::path_home("AppData/Roaming/Python/Python34"),
        fs::path_home("AppData/Roaming/Python/Python37")
      )
    }
  )

  expect_warning(
    path_derive_precommit_exec(),
    "We detected multiple pre-commit executables"
  )
})

test_that("Warns when there are multiple installations found (2x path)", {
  local_mocked_bindings(
    path_derive_precommit_exec_path = function(candidate) {
      c(
        fs::path_home("AppData/Roaming/Python/Python35"),
        fs::path_home("AppData/Roaming/Python/Python37")
      )
    },
    get_os = function(...) {
      c(sysname = "windows")
    },
    path_derive_precommit_exec_win = function() {
      fs::path_home("AppData/Roaming/Python/Python34")
    }
  )
  expect_warning(
    path_derive_precommit_exec(),
    "We detected multiple pre-commit executables"
  )
})

test_that("Warns when there are multiple installations found (path and os)", {
  local_mocked_bindings(
    path_derive_precommit_exec_path = function(candidate) {
      fs::path_home("AppData/Roaming/Python/Python35")
    },
    path_derive_precommit_exec_win = function() {
      fs::path_home("AppData/Roaming/Python/Python34")
    },
    get_os = function(...) {
      c(sysname = "windows")
    },
  )

  expect_warning(
    path_derive_precommit_exec(),
    "We detected multiple pre-commit executables"
  )
})
