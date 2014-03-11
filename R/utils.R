"%||%" <- function(a, b) if (!is.null(a)) a else b


project_name <- function() {
  basename(normalizePath(getwd()))
}
