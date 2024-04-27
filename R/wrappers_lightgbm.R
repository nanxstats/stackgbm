#' Train lightgbm model
#'
#' @param data Training data.
#' @param label Labels.
#' @param params A list of parameters.
#' @param ... Additional parameters.
#'
#' @return A model object.
#'
#' @export
#'
#' @examplesIf is_installed_lightgbm()
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
#' fit <- suppressWarnings(
#'   lightgbm_train(
#'     data = sim_data$x.tr,
#'     label = sim_data$y.tr,
#'     params = list(
#'       objective = "binary",
#'       learning_rate = 0.1,
#'       num_iterations = 100,
#'       max_depth = 3,
#'       num_leaves = 2^3 - 1,
#'       num_threads = 1
#'     ),
#'     verbose = -1
#'   )
#' )
#'
#' fit
lightgbm_train <- function(data, label, params, ...) {
  rlang::check_installed("lightgbm", reason = "to train the model")
  cl <- rlang::call2(
    "lightgbm",
    .ns = "lightgbm",
    data = data,
    label = label,
    params = params,
    ...
  )
  rlang::eval_tidy(cl)
}
