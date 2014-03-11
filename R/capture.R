#' Run some code, capturing an image.
#'
#' @param name unique name for plot. Should not include extension
#' @param code to evaluate and print. Printing ensure that \code{capture_plot}
#'   works well with ggplot2 and lattice graphics.
#' @param path where to save resulting image, defaults to
#'   \code{\link{get_diff_dir}}.
#' @param dev name of graphics device to use, defaults to \code{\link{png}}.
#' @param width,height dimenion, in pixels, of resulting plot
#' @param ... other arguments passed on to the graphics device.
#' @return (invisibly) the path of the created file
#' @export
#' @examples
#' capture_plot("Sequence", plot(1:10))
#' capture_plot("Random", plot(runif(10)))
capture_plot <- function(name, code, path = get_diff_dir(),
                         dev = "png", width = 250, height = 250, ...) {
  stopifnot(is.character(path), length(path) == 1)
  stopifnot(is.character(dev), length(dev) == 1)

  dev_f <- match.fun(dev)
  dev_f(filename = file.path(path, paste0(name, ".", dev)), width = width,
    height = height, ...)
  on.exit(dev.off())

  capture.output(print(code))

  invisible(path)
}
