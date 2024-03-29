% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cv_param_grid.R
\name{cv_param_grid}
\alias{cv_param_grid}
\title{Generate a parameter grid for cross-validation}
\usage{
cv_param_grid(
  n_iterations = c(100, 200, 500, 1000),
  max_depth = c(3, 5, 7, 9),
  learning_rate = c(0.01, 0.05, 0.1, 0.2)
)
}
\arguments{
\item{n_iterations}{A numeric vector of the number of iterations (trees)
for the GBDT model. This is equivalent to \code{nrounds} in XGBoost,
\code{num_iterations} in LightGBM, and \code{iterations} in CatBoost.}

\item{max_depth}{A numeric vector of the maximum tree depths.
This parameter is equivalent to \code{max_depth} in XGBoost and LightGBM,
and \code{depth} in CatBoost.}

\item{learning_rate}{A numeric vector of learning rates for the GBDT model.
This parameter is equivalent to \code{eta} in XGBoost,
\code{learning_rate} in LightGBM, and ignored in CatBoost.}
}
\value{
A list where the names are the parameter names and the values
are vectors of possible values for those parameters.
}
\description{
This function generates a parameter grid to be used in the
cross-validation of gradient boosting decision tree (GBDT) models.
}
\examples{
params <- cv_param_grid(
  n_iterations = c(10, 100),
  max_depth = c(3, 5),
  learning_rate = c(0.01, 0.1)
)
}
