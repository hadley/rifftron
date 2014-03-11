#' Run some code, capturing an image.
#'
#' @param code to evaluate and print. Printing ensure that it works easily
#'   with ggplot2 and lattice graphics.
#' @param path where to save resulting image
#' @param dev name of graphics device to use, defaults to \code{\link{png}}.
#' @param width,height dimenion, in pixels, of resulting plot
#' @param ... other arguments passed on to the graphics device.
#' @return (invisibly) the path of the created file
#' @export
#' @examples
#' capture_plot(plot(1:10), tempfile(fileext = ".png"))
capture_plot <- function(code, path, dev = "png", width = 250, height = 250,
                         ...) {
  stopifnot(is.character(path), length(path) == 1)
  stopifnot(is.character(dev), length(dev) == 1)

  dev <- match.fun(dev)
  dev(filename = path, width = width, height = height, ...)
  on.exit(dev.off())

  capture.output(print(code))

  invisible(path)
}
