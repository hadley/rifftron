git <- function(..., quiet = TRUE) {
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


sha1 <- function(n = 10) {
  git("rev-parse", paste0("--short=", n), "HEAD")
}
