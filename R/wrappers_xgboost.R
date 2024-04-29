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
#' @examplesIf is_installed_xgboost()
#' sim_data <- msaenet::msaenet.sim.binomial(
#'   n = 100,
#'   p = 10,
#'   rho = 0.6,
#'   coef = rnorm(5, mean = 0, sd = 10),
#'   snr = 1,
#'   p.train = 0.8,
#'   seed = 42
#' )
#'
#' xgboost_dmatrix(sim_data$x.tr, label = sim_data$y.tr)
#' xgboost_dmatrix(sim_data$x.te)
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
#' @examplesIf is_installed_xgboost()
#' sim_data <- msaenet::msaenet.sim.binomial(
#'   n = 100,
#'   p = 10,
#'   rho = 0.6,
#'   coef = rnorm(5, mean = 0, sd = 10),
#'   snr = 1,
#'   p.train = 0.8,
#'   seed = 42
#' )
#'
#' x_train <- xgboost_dmatrix(sim_data$x.tr, label = sim_data$y.tr)
#'
#' fit <- xgboost_train(
#'   params = list(
#'     objective = "binary:logistic",
#'     eval_metric = "auc",
#'     max_depth = 3,
#'     eta = 0.1
#'   ),
#'   data = x_train,
#'   nrounds = 100,
#'   nthread = 1
#' )
#'
#' fit
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
