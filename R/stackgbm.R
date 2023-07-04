#' Model stacking for boosted trees
#'
#' Model stacking with a two-layer architecture: first layer being boosted
#' tree models fitted by xgboost, lightgbm, and catboost; second layer being
#' a logistic regression model.
#'
#' @param x Predictor matrix
#' @param y Response vector
#' @param params A list of optimal parameters for boosted tree models.
#' Can be derived from \code{\link{cv_xgboost}}, \code{\link{cv_lightgbm}},
#' and \code{\link{cv_catboost}}.
#' @param nfolds Number of folds. Default is 5.
#' @param seed Random seed for reproducibility
#' @param verbose Show progress?
#'
#' @return Fitted boosted tree models and stacked tree model.
#'
#' @importFrom xgboost xgb.train xgb.DMatrix
#' @importFrom lightgbm lightgbm
#' @importFrom catboost catboost.train catboost.load_pool catboost.predict
#' @importFrom stats glm binomial
#' @importFrom progress progress_bar
#'
#' @export stackgbm
#'
#' @examples
#' # check the vignette for code examples
stackgbm <- function(x, y, params, nfolds = 5L, seed = 42, verbose = TRUE) {
  set.seed(seed)
  nrow_x <- nrow(x)
  index_xgb <- sample(rep_len(1L:nfolds, nrow_x))
  index_lgb <- sample(rep_len(1L:nfolds, nrow_x))
  index_cat <- sample(rep_len(1L:nfolds, nrow_x))

  model_xgb <- vector("list", nfolds)
  model_lgb <- vector("list", nfolds)
  model_cat <- vector("list", nfolds)

  x_glm <- matrix(NA, nrow = nrow_x, ncol = 3L)
  colnames(x_glm) <- c("xgb", "lgb", "cat")

  # xgboost
  pb <- progress_bar$new(
    format = "  fitting xgboost model [:bar] :percent in :elapsed",
    total = nfolds, clear = FALSE, width = 60
  )

  x_xgb <- as.matrix(x)

  for (i in 1L:nfolds) {
    if (verbose) pb$tick()
    xtrain <- x_xgb[index_xgb != i, , drop = FALSE]
    ytrain <- y[index_xgb != i]
    xtest <- x_xgb[index_xgb == i, , drop = FALSE]
    ytest <- y[index_xgb == i]

    xtrain <- xgb.DMatrix(xtrain, label = ytrain)
    xtest <- xgb.DMatrix(xtest)

    fit <- xgb.train(
      params = list(
        objective = "binary:logistic",
        eval_metric = "auc",
        max_depth = params$xgb.max_depth,
        eta = params$xgb.learning_rate
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
    total = nfolds, clear = FALSE, width = 60
  )

  x_lgb <- as.matrix(x)

  for (i in 1L:nfolds) {
    if (verbose) pb$tick()
    xtrain <- x_lgb[index_lgb != i, , drop = FALSE]
    ytrain <- y[index_lgb != i]
    xtest <- x_lgb[index_lgb == i, , drop = FALSE]
    ytest <- y[index_lgb == i]

    fit <- lightgbm(
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
    total = nfolds, clear = FALSE, width = 60
  )

  x_cat <- x

  for (i in 1L:nfolds) {
    if (verbose) pb$tick()
    xtrain <- x_cat[index_cat != i, , drop = FALSE]
    ytrain <- y[index_cat != i]
    xtest <- x_cat[index_cat == i, , drop = FALSE]
    ytest <- y[index_cat == i]

    train_pool <- catboost.load_pool(data = xtrain, label = ytrain)
    test_pool <- catboost.load_pool(data = xtest, label = NULL)
    fit <- catboost.train(
      train_pool, NULL,
      params = list(
        loss_function = "Logloss",
        iterations = params$cat.iterations,
        depth = params$cat.depth,
        logging_level = "Silent"
      )
    )
    model_cat[[i]] <- fit
    x_glm[index_cat == i, "cat"] <- catboost.predict(fit, test_pool, prediction_type = "Probability")
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
