#' Locate the pre-comit executable
#'
#' @param check_if_exists Whether or not to make sure the returned path also
#'  exists.
#' @export
path_pre_commit_exec <- function(check_if_exists = TRUE) {
  final <- getOption("precommit.executable") %>%
    as.character()
  if (!check_if_exists) {
    return(final)
  }
  if (!fs::file_exists(final)) {
    rlang::abort(paste0(
      "pre-commit executable does not exist at ",
      final,
      ". Please locate your pre-commit ",
      "executable and set the R option `precommit.executable` to this ",
      "path so it can be used to perform various pre-commit commands from R."
    ))
  }
  final
}


path_derive_precommit_exec <- function() {
  if (nzchar(from_conda <- path_derive_from_conda())) {
    from_conda
  } else if (nzchar(from_pip <- path_derive_from_pip())) {
    from_pip
  } else {
    ""
  }
}

path_derive_from_conda <- function() {
  tryCatch(
    {
      ls <- reticulate::conda_list()

      path_reticulate <- fs::path_dir(
        ls[ls$name == "r-reticulate", "python"][1]
      )
      derived <- fs::path(
        path_reticulate,
        ifelse(is_windows(), "Scripts", ""),
        ifelse(is_windows(), "pre-commit.exe", "pre-commit")
      )
      unname(ifelse(fs::file_exists(derived), derived, ""))
    },
    error = function(e) ""
  )
}

path_derive_from_pip <- function() {
  if (fs::file_exists(lb <- fs::path_home(".local", "bin", "pre-commit"))) {
    lb
  } else {
    ""
  }
}
