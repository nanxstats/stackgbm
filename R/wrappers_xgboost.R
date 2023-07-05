#' Create xgb.DMatrix object
#'
#' @param data Matrix or file.
#' @param label Labels (optional).
#' @param ... Additional parameters.
#'
#' @return An `xgb.DMatrix` object.
#'
#' @export
#'
#' @examples
#' # Example code
xgboost_dmatrix <- function(data, label = NULL, ...) {
  rlang::check_installed("xgboost", reason = "to create a dataset")
  cl <- if (is.null(label)) {
    rlang::call2("xgb.DMatrix", .ns = "xgboost", data = data, ...)
  } else {
    rlang::call2("xgb.DMatrix", .ns = "xgboost", data = data, label = label, ...)
  }
  rlang::eval_tidy(cl)
}

#' Train xgboost model
#'
#' @param params A list of parameters.
#' @param data Training data.
#' @param nrounds The Maximum number of boosting iterations.
#' @param ... Additional parameters.
#'
#' @return A model object.
#'
#' @export
#'
#' @examples
#' # Example code
xgboost_train <- function(params, data, nrounds, ...) {
  rlang::check_installed("xgboost", reason = "to train the model")
  cl <- rlang::call2(
    "xgb.train",
    .ns = "xgboost",
    params = params,
    data = data,
    nrounds = nrounds,
    ...
  )
  rlang::eval_tidy(cl)
}
