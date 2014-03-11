"%||%" <- function(a, b) if (!is.null(a)) a else b


project_name <- function(base = ".") {
  basename(normalizePath(base))
}

on_cran <- function() {
  !identical(Sys.getenv("NOT_CRAN"), "true")
}

on_travis <- function() {
  identical(Sys.getenv("TRAVIS"), "true")
}

