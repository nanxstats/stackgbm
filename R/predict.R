#' Make predictions from a stackgbm model object
#'
#' @param object A stackgbm model object.
#' @param newx New predictor matrix.
#' @param threshold Decision threshold. Default is 0.5.
#' @param classes The class encoding vector of the predicted outcome.
#'   The naming and order will be respected.
#' @param ... Unused.
#'
#' @return
#' A list of two vectors presenting the predicted classification
#' probabilities and predicted response.
#'
#' @method predict stackgbm
#'
#' @importFrom stats predict
#'
#' @export
#'
#' @examplesIf is_installed_xgboost() && is_installed_lightgbm() && is_installed_catboost()
#' sim_data <- msaenet::msaenet.sim.binomial(
#'   n = 1000,
#'   p = 50,
#'   rho = 0.6,
#'   coef = rnorm(25, mean = 0, sd = 10),
#'   snr = 1,
#'   p.train = 0.8,
#'   seed = 42
#' )
#'
#' params_xgboost <- structure(
#'   list("nrounds" = 200, "eta" = 0.05, "max_depth" = 3),
#'   class = c("cv_params", "cv_xgboost")
#' )
#' params_lightgbm <- structure(
#'   list("num_iterations" = 200, "max_depth" = 3, "learning_rate" = 0.05),
#'   class = c("cv_params", "cv_lightgbm")
#' )
#' params_catboost <- structure(
#'   list("iterations" = 100, "depth" = 3),
#'   class = c("cv_params", "cv_catboost")
#' )
#'
#' fit <- stackgbm(
#'   sim_data$x.tr,
#'   sim_data$y.tr,
#'   params = list(
#'     params_xgboost,
#'     params_lightgbm,
#'     params_catboost
#'   )
#' )
#'
#' predict(fit, newx = sim_data$x.te)
predict.stackgbm <- function(object, newx, threshold = 0.5, classes = c(1L, 0L), ...) {
  nrow_newx <- nrow(newx)
  n_folds <- length(object$model_xgb)

  pred_xgb <- matrix(NA, nrow = nrow_newx, ncol = n_folds)
  pred_lgb <- matrix(NA, nrow = nrow_newx, ncol = n_folds)
  pred_cat <- matrix(NA, nrow = nrow_newx, ncol = n_folds)

  newx_xgb <- as.matrix(newx)
  newx_xgb <- xgboost_dmatrix(newx_xgb)
  for (i in 1L:n_folds) pred_xgb[, i] <- predict(object$model_xgb[[i]], newx_xgb)

  newx_lgb <- as.matrix(newx)
  for (i in 1L:n_folds) pred_lgb[, i] <- predict(object$model_lgb[[i]], newx_lgb)

  newx_cat <- newx
  newx_cat <- catboost_load_pool(data = newx_cat, label = NULL)
  for (i in 1L:n_folds) pred_cat[, i] <- catboost_predict(object$model_cat[[i]], pool = newx_cat, prediction_type = "Probability")

  newx_glm <- data.frame(
    "xgb" = rowMeans(pred_xgb),
    "lgb" = rowMeans(pred_lgb),
    "cat" = rowMeans(pred_cat)
  )

  pred_prob <- unname(predict(object$model_glm, newx_glm, type = "response"))
  pred_resp <- ifelse(pred_prob > threshold, classes[1], classes[2])

  list("prob" = pred_prob, "resp" = pred_resp)
}
