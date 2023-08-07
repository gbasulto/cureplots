test_that("cure_dataframe_variable_names", {

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
  res <- residuals(mod, type = "working")

  ## Calculate CURE plot data
  cure_df <- calculate_cure_dataframe(AADT, res)

  outnames <- c("AADT", "residual", "cumres", "lower", "upper")
  expect_named(cure_df, outnames)
})


