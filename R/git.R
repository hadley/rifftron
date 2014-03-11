git <- function(..., quiet = TRUE) {
  if (!file.exists(".git")) {
    stop("Not in git repo", call. = FALSE)
  }

  options <- paste(..., collapse = " ")
  cmd <- paste0(shQuote(git_path()), " ", options)

  result <- suppressWarnings(
    system(cmd, intern = quiet, ignore.stderr = quiet)
  )

  if (quiet) {
    status <- attr(result, "status") %||% 0
  } else {
    status <- result
    result <- NULL
  }

  if (!identical(as.character(status), "0")) {
    stop("Command failed (", status, ")", call. = FALSE)
  }

  result
}

git_path <- function() {
  # Look on path
  git_path <- Sys.which("git")[[1]]
  if (git_path != "") return(git_path)

  # On Windows, look in common locations
  if (.Platform$OS.type == "windows") {
    look_in <- c(
      "C:/Program Files/Git/bin/git.exe",
      "C:/Program Files (x86)/Git/bin/git.exe"
    )
    found <- file.exists(look_in)
    if (any(found)) return(look_in[found][1])
  }

  stop("Git does not seem to be installed on your system.", call. = FALSE)
}


#' Determine sha1 of the current git checkout
#'
#' A \code{-uncommited} suffix is added if the repo currently has uncommited
#' changes that are not reflected in the SHA.
#'
#' @param n Number of characters to truncate sha1 to. Defaults to 10
#'   because that's what github does.
#' @export
sha1 <- function(n = 10) {
  sha <- git("rev-parse", paste0("--short=", n), "HEAD")
  if (!uncommitted()) return(sha)

  paste0(sha, "-uncommited")
}

uncommitted <- function() {
  system("git diff-index --quiet --cached HEAD") == 1 ||
    system("git diff-files --quiet") == 1
}

