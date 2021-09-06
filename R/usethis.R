#' Tidy the description
#'
#' @export
#' @family hook script helpers
use_tidy_description <- function() {
  desc <- desc::description$new()
  tidy_desc(desc)
  desc$write()
  invisible(TRUE)
}
