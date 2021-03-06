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

  # message("Changing diff path to ", path)
  old <- rifftron_env$diff_dir
  rifftron_env$diff_dir <- path
  invisible(old)
}

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
#'   are uploaded. Defaults to \code{\link{get_diff_dir}()}.
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

#' Run all R files in a directory or package and upload visual results.
#'
#' \code{riff_travis} runs code in the package environment, so that
#' non-exported functions can be tested.
#'
#' @param path Directory of R files to execute
#' @param env Environment in which to execute code. If \code{NULL}, defaults
#'   to a new environment inheriting from the global environment.
#' @param ... Additional arguments passed on to \code{}
#' @export
#' @examples
#' \donttest{
#' riff_travis()
#' riff_dir("tests/rifftron")
#' }
riff_dir <- function(path, env = NULL, ...) {
  # Save images in new path, and cleanup on exit
  old <- set_diff_dir(tempfile(), create = TRUE)
  on.exit(unlink(get_diff_dir(), recursive = TRUE), add = TRUE)
  on.exit(set_diff_dir(old), add = TRUE)

  if (!file_test('-d', path)) {
    stop("Directory ", path, " does not exist.", call. = FALSE)
  }

  # Source all files in directory
  r_files <- dir(path, pattern = "\\.[Rr]$", full.names = TRUE)
  if (length(r_files) == 0) {
    stop("No R files found in ", path, call. = FALSE)
  }
  if (is.null(env)) {
    env <- new.env(parent = globalenv())
  }
  for (path in r_files) sys.source(path, envir = env, chdir = TRUE)

  # Upload to difftron
  upload_dir(...)
}

#' @rdname riff_dir
#' @export
riff_travis <- function() {
  if (!on_travis()) {
    message("Not on travis. Skipping")
    return(TRUE)
  }

  package <- gsub("\\.Rcheck$", "", project_name(".."))
  require(package, character.only = TRUE)
  env <- new.env(parent = asNamespace(package))

  riff_dir("rifftron", env, project = package, set_name = travis_sha())
}

travis_sha <- function() {
  substr(Sys.getenv("TRAVIS_COMMIT"), 1, 10)
}
