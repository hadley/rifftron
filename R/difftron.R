#' Retrieve the difftron api key.
#'
#' If not supplied explicitly, this should be stored in an environment
#' variable called \code{DIFFTRON_KEY}. Set this in you \code{.Renviron}.
#' If you set in a project specific {.Renviron}, make sure you exclude from
#' git etc.
#'
#' @export
api_key <- function() {
  secret <- Sys.getenv("DIFFTRON_KEY")
  if (secret == "") {
    stop("Couldn't find key in environment variable DIFFTRON_KEY",
      call. = FALSE)
  }
  secret
}

difftron_url <- function(...) {
  httr::modify_url("https://difftron.com/", ...)
}

difftron_auth <- function(key = api_key()) {
  httr::authenticate(key, "", "basic")
}

#' PUT an imageset.
#'
#' @param project,set Name of project and image set
#' @param path character vector of images to upload
#' @param key difftron api key, see \code{\link{api_key}} for more details
#' @keywords internal
#' @examples
#' \donttest{
#' png("test.png"); plot(runif(10)); dev.off()
#' put_imageset("test", "test2", "test.png")
#' unlink("test.png")
#' }
put_imageset <- function(project, set, path, key = api_key()) {
  url <- difftron_url(path = file.path(project, set))
  files <- lapply(path, RCurl::fileUpload)
  names(files) <- "image"

  r <- httr::PUT(url, difftron_auth(key), body = files)
  httr::stop_for_status(r)

  invisible(TRUE)
}
