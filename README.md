
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cureplots

<!-- badges: start -->
<!-- badges: end -->

The goal of cureplots is to …

## Installation

You can install the development version of cureplots from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("gbasulto/cureplots")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(cureplots)
library(ggplot2)
## basic example code

set.seed(2000)

## Define parameters
beta <- c(-1, 0.3, 3)

## Simulate idependent variables
n <- 900
AADT <- c(runif(n, min = 2000, max = 150000))
nlanes <- sample(x = c(2, 3, 4), size = n, replace = TRUE)
LNAADT <- log(AADT)

## Simulate dependent variable
theta <- exp(beta[1] + beta[2] * LNAADT + beta[3] * nlanes)
y <- rpois(n, theta)

## Fit model
mod <- glm(y ~ LNAADT + nlanes, family = poisson)

## Calculate residuals
res <- residuals(mod)

## Calculate CURE plot data
cure_df <- calculate_cure_dataframe(AADT, res)
#> Covariate: AADT

head(cure_df)
#> # A tibble: 6 × 5
#>    AADT residual cumres  lower upper
#>   <dbl>    <dbl>  <dbl>  <dbl> <dbl>
#> 1 2363.   -0.297 -0.297 -0.583 0.583
#> 2 2435.    0.438  0.140 -1.04  1.04 
#> 3 2724.    1.37   1.51  -2.88  2.88 
#> 4 2978.   -1.89  -0.380 -4.69  4.69 
#> 5 3007.   -0.484 -0.864 -4.78  4.78 
#> 6 3149.   -1.85  -2.72  -5.99  5.99

## Providing CURE data frame
cure_plot(cure_df)
#> CURE data frame was provided. Its first column, AADT, will be used.
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r

## Providing glm object
cure_plot(mod, "LNAADT")
```

<img src="man/figures/README-example-2.png" width="100%" />

<!-- 
To do list 
1. dd 
2. ccc 
-->
