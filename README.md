# stackgbm <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/nanxstats/stackgbm/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nanxstats/stackgbm/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

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

## Related projects

For a more comprehensive and flexible implementation of model stacking, see
[stacks](https://stacks.tidymodels.org) in tidymodels
and [StackingClassifier](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.StackingClassifier.html)
in scikit-learn.

## Code of Conduct

Please note that the stackgbm project is released with a
[Contributor Code of Conduct](https://nanx.me/stackgbm/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
