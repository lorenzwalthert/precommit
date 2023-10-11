is_windows <- function() {
  identical(.Platform$OS.type, "windows")
}

is_url <- function(text) {
  if (length(text) < 1) {
    return(FALSE)
  }
  conn <- file(text)
  on.exit(close(conn))
  conn %>%
    inherits("url")
}

file_exists <- function(...) {
  fs::file_exists(fs::path_expand(...))
}


path_if_exist <- function(...) {
  path <- c(...)
  path[file_exists(path)]
}

is_conda_installation <- function() {
  grepl(
    "conda3?/envs/r-precommit/(bin|Scripts)/pre-commit(\\.exe)?",
    getOption("precommit.executable")
  )
}

is_package <- function(root = here::here()) {
  rlang::with_handlers(
    rprojroot::find_package_root_file(path = root),
    error = function(e) NULL
  ) %>%
    is.null() %>%
    magrittr::not()
}

#' Name the input
#'
#' @param x A vector.
#' @param f How to transform the input `x` into a name.
#' @keywords internal
ensure_named <- function(x, candidate_name = NULL, f = identity) {
  if (is.null(names(x))) {
    if (is.null(candidate_name)) {
      names(x) <- f(x)
    } else {
      names(x) <- candidate_name
    }
  }
  x
}


#' Create the path to the precommit R.cache cache
#'
#' This function is only exported for use in hook scripts, but it's not intended
#' to be called by the end-user directly.
#' @param hook_id The id of the hook for which we want the relative cache
#'   directory.
#' @family hook script helpers
#' @keywords internal
#' @export
dirs_R.cache <- function(hook_id) {
  file.path("precommit", hook_id)
}

#' Initiate git and configure it
#'
#' In particular, to avoid CRAN errors
#' [lorenzwalthert/precommit#320](https://github.com/lorenzwalthert/precommit/issues/320).
#' @param path The root of the repo.
#' @keywords internal
git_init <- function(path = ".") {
  git2r::init(path = path)
  git2r::config(
    user.name = "testthat",
    user.email = "agent@testthat.com",
    core.autocrlf = "true"
  )
}

#' Provide a singular interface for hook calls to docopt
#'
#' docopt provides different processing for a single string
#' than an array/vector. As `"string"`` and `c("string")`
#' are semantically equivalent in R, this can create problems
#' when a single parameter is provided. Thus, this function
#' wraps docopt to ensure that the args will always be
#' interpreted as a vector.
#'
#' This function is only exported for use in hook scripts, but it's not intended
#' to be called by the end-user directly.
#' @param doc `character` vector with command line specification.
#' @param args `character` vector of command line arguments.
#'   Defaults to `commandArgs(trailingOnly=TRUE)`.
#' @param ... Additional parameters passed to `docopt`.
#' @family hook script helpers
#' @keywords internal
#' @export
precommit_docopt <- function(doc, args = commandArgs(trailingOnly = TRUE), ...) {
  docopt::docopt(doc, c(args, ""), ...)
}

#' Read the refs corresponding to a hooks repo
#' @keywords internal
rev_read <- function(path = ".pre-commit-config.yaml", repo = hooks_repo) {
  config <- yaml::read_yaml(path)
  idx <- purrr::map_chr(config$repos, ~ .x$repo) %>%
    grep(repo, ., fixed = TRUE)
  if (length(idx) < 1) {
    return(NA)
  } else {
    config$repos[[idx]]$rev
  }
}

rev_as_pkg_version <- function(rev) {
  package_version(gsub("^v", "", rev))
}

has_git <- function() {
  nzchar(Sys.which("git"))
}

is_git_repo <- function(root = here::here()) {
  withr::local_dir(root)
  if (has_git()) {
    rlang::with_handlers(
      {
        output <- call_and_capture(
          "git",
          c("rev-parse", "--is-inside-work-tree")
        )
        output$exit_status == 0 && as.logical(toupper(output$stdout))
      },
      erorr = function(...) FALSE
    )
  } else {
    dir.exists(".git")
  }
}
