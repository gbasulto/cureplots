# CURE Plot

CURE Plot

## Usage

``` r
cure_plot(x, covariate = NULL, n_resamples = 0)
```

## Arguments

- x:

  Either a data frame produced with
  [`calculate_cure_dataframe`](https://gbasulto.github.io/cureplots/reference/calculate_cure_dataframe.md),
  in that case, the first column is used to produce CURE plot; or
  regression model for count data (e.g., Poisson) adjusted with
  [`glm`](https://rdrr.io/r/stats/glm.html) or
  [`gam`](https://rdrr.io/pkg/mgcv/man/gam.html).

- covariate:

  Required when `x` is model fit.

- n_resamples:

  Number of resamples to overlay on CURE plot. Zero is the default.

## Value

A CURE plot generated with ggplot2.

## Examples

``` r
## basic example code

set.seed(2000)

## Define parameters
beta <- c(-1, 0.3, 3)

## Simulate independent variables
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
res <- residuals(mod, type = "response")

## Calculate CURE plot data
cure_df <- calculate_cure_dataframe(AADT, res)
#> Covariate: AADT

head(cure_df)
#> # A tibble: 6 × 5
#>    AADT residual  cumres  lower upper
#>   <dbl>    <dbl>   <dbl>  <dbl> <dbl>
#> 1 2363.   -233.   -233.   -457.  457.
#> 2 2435.     17.2  -216.   -459.  459.
#> 3 2724.    246.     29.9  -666.  666.
#> 4 2978.  -1539.  -1509.  -3081. 3081.
#> 5 3007.    -19.5 -1528.  -3081. 3081.
#> 6 3149.   -338.  -1867.  -3151. 3151.

## Providing CURE data frame
cure_plot(cure_df)
#> CURE data frame was provided. Its first column, AADT, will be used.


## Providing glm object
cure_plot(mod, "LNAADT")
#> Covariate LNAADT will be used to produce CURE plot.


## Providing glm object adding resamples cumulative residuals
cure_plot(mod, "LNAADT", n_resamples = 3)
#> Covariate LNAADT will be used to produce CURE plot.
```
