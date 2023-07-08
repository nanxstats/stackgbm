# stackgbm <img src="man/figures/logo.png" align="right" width="120" />

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

stackgbm offers a minimalist implementation of model stacking
([Wolpert, 1992](https://doi.org/10.1016/S0893-6080(05)80023-1))
for gradient boosted tree models built by
xgboost ([Chen and Guestrin, 2016](https://doi.org/10.1145/2939672.2939785)),
lightgbm ([Ke et al., 2017](https://papers.nips.cc/paper/6907-lightgbm-a-highly-efficient-gradient-boosting-decision)),
and catboost ([Prokhorenkova et al., 2018](https://papers.nips.cc/paper/7898-catboost-unbiased-boosting-with-categorical-features)).

## Installation

Install from GitHub:

```r
remotes::install_github("nanxstats/stackgbm")
```

To install all dependencies, check out the instructions from
[manage dependencies](https://github.com/nanxstats/stackgbm/wiki/Manage-dependencies).

## Model

stackgbm implements a classic two-layer stacking model: the first layer
generates "features" produced by gradient boosting trees.
The second layer is a logistic regression that uses these features as inputs.
The code is rewritten from our
[2nd place solution](https://github.com/nanxstats/bcpm-msaenet) for a
precisionFDA brain cancer machine learning challenge in 2020.

## Design principles

Provide a minimalist, research-friendly code base for GBDT model stacking.

- **Targeted models**\
  Focus on the three most impactful GBDT model
  implementations: XGBoost, LightGBM, and CatBoost,
  to ensure high performance without unnecessary complexity.
- **Grid search and cross-validation**\
  Embrace traditional grid search and cross-validation for parameter tuning,
  to make it robust and understandable.
- **Key parameter tuning**\
  Provide tuning options for the most impactful parameters
  (learning rate, maximum depth of a tree, and number of iterations) across
  GBDT implementations to avoid the risk of overfitting and complexity
  associated with excessive parameter tuning.
- **Effective defaults**\
  The default parameter grid balances performance and computational cost,
  performing effectively across a wide range of scenarios.
- **Base R implementation**\
  Build with base R to ensure it is easy to understand, modify, and extend.

## Related projects

For a more comprehensive and flexible implementation of model stacking, see
[stacks](https://stacks.tidymodels.org) in tidymodels
and [StackingClassifier](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.StackingClassifier.html)
in scikit-learn.

## Code of Conduct

Please note that the stackgbm project is released with a
[Contributor Code of Conduct](https://nanx.me/stackgbm/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
