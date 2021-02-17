#' @details
#'
#' rhdb includes the following package options:
#'
#' - rhdb.try_url_n - this specifies the number of times the API url will be
#' tried before aborting with an error. The default is 5.
#'
#' @keywords internal
"_PACKAGE"

#' @importFrom assertthat assert_that
NULL

.onLoad <- function(libname, pkgname) {
  op <- options()
  op_rhdb <- list(
    rhdb.try_url_n = 5
  )
  toset <- !(names(op_rhdb) %in% names(op))
  if(any(toset)) options(op_rhdb[toset])

  invisible()
}
