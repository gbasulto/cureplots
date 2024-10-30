test_that("resample-returns-expected-size", {
  library(cureplots)
  library(ggplot2)
  #  ## basic example
  #  set.seed(2000)
  #  ## Define parameters.
  beta <- c(-1, 0.3, 3)
  #  ## Simulate independent variables
  n <- 900
  AADT <- c(runif(n, min = 2000, max = 150000))
  nlanes <- sample(x = c(2, 3, 4), size = n, replace = TRUE)
  LNAADT <- log(AADT)
  #  ## Simulate dependent variable
  theta <- exp(beta[1] + beta[2] * LNAADT + beta[3] * nlanes)
  y <- rpois(n, theta)
  #  ## Fit model
  mod <- glm(y ~ LNAADT + nlanes, family = poisson)
  #  ## Calculate residuals
  res <- residuals(mod, type = "response")
  #  ## Calculate CURE plot data
  cure_df <- calculate_cure_dataframe(AADT, res)
  resampled_residuals_tbl <- resample_residuals(AADT, res, n_resamples = 7)

  nr <- nrow(resampled_residuals_tbl)
  nc <- ncol(resampled_residuals_tbl)
  expected_nc <- ncol(cure_df) + 1

  expect_true((nr == 7 * n) & (nc == expected_nc))
})
