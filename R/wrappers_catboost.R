#' Create a dataset
#'
#' @param data Predictors.
#' @param label Labels.
#' @param ... Additional parameters.
#'
#' @return A `catboost.Pool` object.
#'
#' @export
#'
#' @examples
#' # Example code
catboost_load_pool <- function(data, label = NULL, ...) {
  rlang::check_installed("catboost", reason = "to create a dataset")
  cl <- rlang::call2(
    "catboost.load_pool",
    .ns = "catboost",
    data = data,
    label = label,
    ...
  )
  rlang::eval_tidy(cl)
}

#' Train the model
#'
#' @param learn_pool Training dataset.
#' @param test_pool Testing dataset.
#' @param params A list of training parameters.
#'
#' @return A model object.
#'
#' @export
#'
#' @examples
#' # Example code
catboost_train <- function(learn_pool, test_pool = NULL, params = list()) {
  rlang::check_installed("catboost", reason = "to train the model")
  cl <- rlang::call2(
    "catboost.train",
    .ns = "catboost",
    learn_pool = learn_pool,
    test_pool = test_pool,
    params = params
  )
  rlang::eval_tidy(cl)
}

#' Predict based on the model
#'
#' @param model The trained model.
#' @param pool The dataset to predict on.
#' @param prediction_type Prediction type.
#' @param ... Additional parameters.
#'
#' @return Predicted values.
#'
#' @export
#'
#' @examples
#' # Example code
catboost_predict <- function(model, pool, prediction_type = "Probability", ...) {
  rlang::check_installed("catboost", reason = "to predict based on the model")
  cl <- rlang::call2(
    "catboost.predict",
    .ns = "catboost",
    model = model,
    pool = pool,
    prediction_type = prediction_type,
    ...
  )
  rlang::eval_tidy(cl)
}
