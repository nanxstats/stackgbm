#' Is xgboost installed?
#'
#' @return `TRUE` if installed, `FALSE` if not.
#'
#' @export
#'
#' @examples
#' is_installed_xgboost()
is_installed_xgboost <- function() {
  rlang::is_installed("xgboost")
}

#' Is lightgbm installed?
#'
#' @return `TRUE` if installed, `FALSE` if not.
#'
#' @export
#'
#' @examples
#' is_installed_lightgbm()
is_installed_lightgbm <- function() {
  rlang::is_installed("lightgbm")
}

#' Is catboost installed?
#'
#' @return `TRUE` if installed, `FALSE` if not.
#'
#' @export
#'
#' @examples
#' is_installed_catboost()
is_installed_catboost <- function() {
  rlang::is_installed("catboost")
}
