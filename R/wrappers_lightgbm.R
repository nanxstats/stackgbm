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
#' @examples
#' # Example code
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
