#' Check if we should run roxygen.
#'
#' This is the case if a new or replaced/removed line contains a roxygen2
#' comment in a file that is staged.
#' This function is only exported for use in hook scripts, but it's not intended
#' to be called by the end-user directly.
#' @param root The root of the git repo.
#' @return
#' A logical vector of length 1.
#' @keywords internal
#' @family hook script helpers
#' @examples
#' \dontrun{
#' diff_requires_run_roxygenize()
#' }
#' @export
diff_requires_run_roxygenize <- function(root = ".") {
  git_raw_diff <- withr::with_dir(
    root, call_and_capture("git", c("diff", "--cached"))
  )$stdout
  is_roxygen <- grepl("^(\\+|-)#'", git_raw_diff)
  if (any(is_roxygen)) {
    return(TRUE)
  } else {
    # check if formals were changed
    # we invalidate the cache on formal change, even if it is not sure they are
    # documented with roxygen. This is easy, cheap and safe. Might give false
    # positive (invalidates in cases where it's not necessary).
    without_comments <- gsub("#.*", "", git_raw_diff)
    any(grep("function(", without_comments, fixed = TRUE))
  }
}

#' Assert if all dependencies are installed
#'
#' This function is only exported for use in hook scripts, but it's not intended
#' to be called by the end-user directly.
#' @family hook script helpers
#' @keywords internal
#' @export
roxygen_assert_additional_dependencies <- function() {
  out <- rlang::with_handlers(
    # roxygen2 will load: https://github.com/r-lib/roxygen2/issues/771
    pkgload::load_all(quiet = TRUE),
    error = function(e) {
      e
    }
  )
  if (
    inherits(out, "packageNotFoundError") ||
      ("message" %in% names(out) && (
        grepl("Dependency package(\\(s\\))? .* not available", out$message) ||
          grepl("Failed to load", out$message)
      ))
  ) {
    # case used in package but not installed
    rlang::abort(paste0(
      "The roxygenize hook requires all dependencies of your package to be listed in ",
      "the file `.pre-commit-config.yaml`. ",
      "Call `precommit::snippet_generate('additional-deps-roxygenize')` ",
      "to generate that list or, to completely deactivate the hook, ",
      "comment out all lines corresponding to that hook under \n\n",
      "    -   id: roxygenize\n",
      "        some_key_under_id_roxygenize: comment-out-as-well\n",
      "    -   id: some-other-hook-do-not-comment-out\n\n",
      "The initial error (from `pkgload::load_all()`) was: ",
      conditionMessage(out), ".\n\n"
    ))
  }
}

#' Roxygen and add a cache entry
#'
#' This function is only exported for use in hook scripts, but it's not intended
#' to be called by the end-user directly.
#' @inheritParams R.cache::saveCache
#' @family hook script helpers
#' @keywords internal
#' @export
#' @importFrom R.cache saveCache
# fails if accessed with R.cache::saveCache()!
roxygenize_with_cache <- function(key, dirs) {
  out <- rlang::with_handlers(
    roxygen2::roxygenise(),
    error = function(e) e
  )
  if (
    inherits(out, "packageNotFoundError") ||
      ("message" %in% names(out) && grepl("Dependency package(\\(s\\))? .* not available", out$message))
  ) {
    rlang::abort(paste0(
      conditionMessage(out),
      " Please add the package as a dependency to ",
      "`.pre-commit-config.yaml` -> `id: roxygenize` -> ",
      "`additional_dependencies` and try again. The package must be ",
      "specified so `renv::install()` understands it, e.g. like this:\n\n",
      "    -   id: roxygenize",
      "
        additional_dependencies:
        - r-lib/pkgapi\n\n"
    ))
  } else if (inherits(out, "error")) {
    rlang::abort(conditionMessage(out))
  } else if (inherits(out, "warning")) {
    rlang::warn(conditionMessage(out))
  }
  saveCache(object = Sys.time(), key = key, dirs = dirs)
}
