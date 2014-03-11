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
  } else {
    message("Using secret stored in environment variable DIFFTRON_KEY")
  }
  secret
}
