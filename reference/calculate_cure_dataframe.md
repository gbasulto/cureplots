# Calculate CURE Dataframe

Calculate CURE Dataframe

## Usage

``` r
calculate_cure_dataframe(covariate_values, residuals)
```

## Arguments

- covariate_values:

  name to be plot. With or without quotes.

- residuals:

  Residuals.

## Value

A data frame with five columns: independent variable, residuals,
cumulative residuals, lower confidence interval limit, and upper
confidence interval limit.

## Examples

``` r
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
```
