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
set_diff_dir(tempfile(), create = TRUE)

#' @export
#' @rdname set_diff_dir
get_diff_dir <- function() rifftron_env$diff_dir

#' Upload all files in a directory.
#'
#' @param set_name Name of the image set. Defaults to the \code{\link{sha1}}
#'   of the current git commit. Manually override if you're not using git.
#' @param project Name of the project. Defaults to the name of the current
#'   directory
#' @param path Path where images are located. All files ending in \code{.png}
#'   are uploaded. Defaults to \code{\link{get_diff_dir()}}
#' @param key difftron api get. See \code{\link{api_key}} for more details.
#' @export
#' @examples
#' \donttest{
#' set_diff_dir(tempfile(), create = TRUE)
#' capture_plot("Sequence", plot(1:10))
#' capture_plot("Random", plot(runif(10)))
#' upload_dir()
#' }
upload_dir <- function(set_name = sha1(), project = project_name(),
                     path = get_diff_dir(), key = api_key()) {

  images <- dir(path, recursive = TRUE, pattern = "\\.png$", full.names = TRUE)
  if (length(images) == 0) stop("No images found.", call. = FALSE)

  message("Uploading ", length(images), " images to imageset ", project, "/",
    set_name)
  put_imageset(project, set_name, images, key)
}
