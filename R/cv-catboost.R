#' catboost - parameter tuning and model selection with k-fold cross-validation and grid search
#'
#' @param x Predictor matrix
#' @param y Response vector
#' @param nfolds Number of folds. Default is 5.
#' @param seed Random seed for reproducibility
#' @param verbose Show progress?
#' @param iterations Grid vector for the parameter \code{iteractions}.
#' @param depth Grid vector for the parameter \code{depth}.
#' @param ncpus Number of CPU cores to use. Defaults is all detectable cores.
#'
#' @return A data frame containing the complete tuning grid and the AUC values,
#' with the best parameter combination and the highest AUC value.
#'
#' @export cv_catboost
#'
#' @examples
#' # check the vignette for code examples
cv_catboost <- function(
  x, y, nfolds = 5L, seed = 42, verbose = TRUE,
  iterations = c(10, 50, 100, 200, 500, 1000),
  depth = c(2, 3, 4, 5),
  ncpus = parallel::detectCores()) {
  set.seed(seed)
  nrow_x <- nrow(x)
  index <- sample(rep_len(1L:nfolds, nrow_x))
  df_grid <- expand.grid(
    "iterations" = iterations,
    "depth" = depth,
    "metric" = NA
  )
  nrow_grid <- nrow(df_grid)

  # x <- as.matrix(x) # uncomment to use non-categorical features

  pb <- progress_bar$new(
    format = "  searching grid [:bar] :percent in :elapsed",
    total = nrow_grid * nfolds, clear = FALSE, width = 60
  )

  for (j in 1L:nrow_grid) {
    ypred <- matrix(NA, ncol = 2L, nrow = nrow_x)
    for (i in 1L:nfolds) {
      if (verbose) pb$tick()

      xtrain <- x[index != i, , drop = FALSE]
      ytrain <- y[index != i]
      xtest <- x[index == i, , drop = FALSE]
      ytest <- y[index == i]

      train_pool <- catboost.load_pool(data = xtrain, label = ytrain)
      test_pool <- catboost.load_pool(data = xtest, label = NULL)
      fit <- catboost.train(
        train_pool, NULL,
        params = list(
          loss_function = "Logloss",
          iterations = df_grid[j, "iterations"],
          depth = df_grid[j, "depth"],
          logging_level = "Silent",
          thread_count = ncpus
        )
      )
      ypredvec <- catboost.predict(fit, test_pool, prediction_type = "Probability")
      ypred[index == i, 1L] <- ytest
      ypred[index == i, 2L] <- ypredvec
    }
    colnames(ypred) <- c("y.real", "y.pred")
    df_grid[j, "metric"] <- as.numeric(pROC::auc(ypred[, "y.real"], ypred[, "y.pred"], quiet = TRUE))
  }

  best_row <- which.max(df_grid$metric)
  best_metric <- df_grid$metric[best_row]
  best_iterations <- df_grid$iterations[best_row]
  best_depth <- df_grid$depth[best_row]

  list(
    df = df_grid,
    metric = best_metric,
    iterations = best_iterations,
    depth = best_depth
  )
}
