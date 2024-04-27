#' Model stacking for boosted trees
#'
#' Model stacking with a two-layer architecture: first layer being boosted
#' tree models fitted by xgboost, lightgbm, and catboost; second layer being
#' a logistic regression model.
#'
#' @param x Predictor matrix.
#' @param y Response vector.
#' @param params A list of optimal parameters for boosted tree models.
#'   Can be derived from [cv_xgboost()], [cv_lightgbm()], and [cv_catboost()].
#' @param n_folds Number of folds. Default is 5.
#' @param seed Random seed for reproducibility.
#' @param verbose Show progress?
#'
#' @return Fitted boosted tree models and stacked tree model.
#'
#' @importFrom stats glm binomial
#' @importFrom progress progress_bar
#'
#' @export stackgbm
#'
#' @examplesIf is_installed_xgboost() && is_installed_lightgbm() && is_installed_catboost()
#' # Check the vignette for code examples
stackgbm <- function(x, y, params, n_folds = 5L, seed = 42, verbose = TRUE) {
  set.seed(seed)
  nrow_x <- nrow(x)
  index_xgb <- sample(rep_len(1L:n_folds, nrow_x))
  index_lgb <- sample(rep_len(1L:n_folds, nrow_x))
  index_cat <- sample(rep_len(1L:n_folds, nrow_x))

  model_xgb <- vector("list", n_folds)
  model_lgb <- vector("list", n_folds)
  model_cat <- vector("list", n_folds)

  x_glm <- matrix(NA, nrow = nrow_x, ncol = 3L)
  colnames(x_glm) <- c("xgb", "lgb", "cat")

  # xgboost
  pb <- progress_bar$new(
    format = "  fitting xgboost model [:bar] :percent in :elapsed",
    total = n_folds, clear = FALSE, width = 60
  )

  x_xgb <- as.matrix(x)

  for (i in 1L:n_folds) {
    if (verbose) pb$tick()
    xtrain <- x_xgb[index_xgb != i, , drop = FALSE]
    ytrain <- y[index_xgb != i]
    xtest <- x_xgb[index_xgb == i, , drop = FALSE]
    ytest <- y[index_xgb == i]

    xtrain <- xgboost_dmatrix(xtrain, label = ytrain)
    xtest <- xgboost_dmatrix(xtest)

    fit <- xgboost_train(
      params = list(
        objective = "binary:logistic",
        eval_metric = "auc",
        max_depth = params$xgb.max_depth,
        eta = params$xgb.eta
      ),
      data = xtrain,
      nrounds = params$xgb.nrounds
    )

    model_xgb[[i]] <- fit
    x_glm[index_xgb == i, "xgb"] <- predict(fit, xtest)
  }

  # lightgbm
  pb <- progress_bar$new(
    format = "  fitting lightgbm model [:bar] :percent in :elapsed",
    total = n_folds, clear = FALSE, width = 60
  )

  x_lgb <- as.matrix(x)

  for (i in 1L:n_folds) {
    if (verbose) pb$tick()
    xtrain <- x_lgb[index_lgb != i, , drop = FALSE]
    ytrain <- y[index_lgb != i]
    xtest <- x_lgb[index_lgb == i, , drop = FALSE]
    ytest <- y[index_lgb == i]

    fit <- lightgbm_train(
      data = xtrain,
      label = ytrain,
      params = list(
        objective = "binary",
        learning_rate = params$lgb.learning_rate,
        num_iterations = params$lgb.num_iterations,
        max_depth = params$lgb.max_depth,
        num_leaves = 2^params$lgb.max_depth - 1
      ),
      verbose = -1
    )

    model_lgb[[i]] <- fit
    x_glm[index_lgb == i, "lgb"] <- predict(fit, xtest)
  }

  # catboost
  pb <- progress_bar$new(
    format = "  fitting catboost model [:bar] :percent in :elapsed",
    total = n_folds, clear = FALSE, width = 60
  )

  x_cat <- x

  for (i in 1L:n_folds) {
    if (verbose) pb$tick()
    xtrain <- x_cat[index_cat != i, , drop = FALSE]
    ytrain <- y[index_cat != i]
    xtest <- x_cat[index_cat == i, , drop = FALSE]
    ytest <- y[index_cat == i]

    train_pool <- catboost_load_pool(data = xtrain, label = ytrain)
    test_pool <- catboost_load_pool(data = xtest, label = NULL)
    fit <- catboost_train(
      train_pool, NULL,
      params = list(
        loss_function = "Logloss",
        iterations = params$cat.iterations,
        depth = params$cat.depth,
        logging_level = "Silent"
      )
    )
    model_cat[[i]] <- fit
    x_glm[index_cat == i, "cat"] <- catboost_predict(fit, pool = test_pool, prediction_type = "Probability")
  }

  # logistic regression
  df <- as.data.frame(cbind(y, x_glm))
  names(df)[1] <- "y"
  model_glm <- glm(y ~ ., data = df, family = binomial())

  lst <- list(
    "model_xgb" = model_xgb,
    "model_lgb" = model_lgb,
    "model_cat" = model_cat,
    "model_glm" = model_glm
  )
  class(lst) <- "stackgbm"
  lst
}
