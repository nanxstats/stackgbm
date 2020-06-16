# stackgbm

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

stackgbm offers a minimalist implementation of model stacking ([Wolpert, 1992](https://doi.org/10.1016/S0893-6080(05)80023-1)) for gradient boosted tree models built by xgboost ([Chen and Guestrin, 2016](https://doi.org/10.1145/2939672.2939785)), lightgbm ([Ke et al., 2017](https://papers.nips.cc/paper/6907-lightgbm-a-highly-efficient-gradient-boosting-decision)), and catboost ([Prokhorenkova et al., 2018](https://papers.nips.cc/paper/7898-catboost-unbiased-boosting-with-categorical-features)).

# Design

stackgbm implements a classic two-layer stacking model: the first layer generates "features" produced by gradient boosting trees. The second layer is a logistic regression that uses these features as inputs. The code is derived from our [2nd place solution](https://github.com/nanxstats/bcpm-msaenet) for a precisionFDA brain cancer machine learning challenge in 2020.

To make sure the package is easy to understand, modify, and extend, we choose to build this package with base R without any special frameworks or dialects. We also only exposed the most essential tunable parameters for the boosted tree models (learning rate, maximum depth of a tree, and number of iterations).

## Installation

Install from GitHub:

```r
remotes::install_github("nanxstats/stackgbm")
```

As of June 2020, all of the depended R packages are installable from CRAN, except for:

- lightgbm: follow the official [installation guide](https://github.com/microsoft/LightGBM/tree/master/R-package).
- catboost: follow the official [installation guide](https://catboost.ai/docs/concepts/r-installation.html).

## License

stackgbm is free and open source software, licensed under GPL-3.
