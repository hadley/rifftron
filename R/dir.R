rifftron_env <- new.env(parent = emptyenv())

#' Get and set diff directory.
#'
#' By default, all images created by rifftron will be stored in this
#' directory, so you can easily upload a complete image set in a single
#' step.  This defaults to a session-specific temporary directory.
#'
#' @param path path in which to store temporary images
#' @param create If \code{TRUE} will create directory if needed, otherwise
#'   will throw error if directory is missing
#' @export
#' @return \code{set_diff_dir()} invisibly returns old path.
set_diff_dir <- function(path, create = FALSE) {
  if (create) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  } else {
    stopifnot(file.exists(path))
  }

  old <- rifftron_env$diff_dir
  rifftron_env$diff_dir <- path
  invisible(old)
}
set_diff_dir(tempdir(), create = TRUE)

#' @export
#' @rdname set_diff_dir
get_diff_dir <- function() rifftron_env$diff_dir
