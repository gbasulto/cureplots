test_that("ggplot object is genererated", {
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
  res <- residuals(mod, type = "working")

  ## Calculate CURE plot data
  cure_df <- calculate_cure_dataframe(AADT, res)

  head(cure_df)

  ## Providing CURE data frame
  cure_plot(cure_df)

  ## Providing glm object
  xx <- cure_plot(mod, "LNAADT")$data
  dims <- dim(xx)

  expect_equal(dims[1], 900)
  expect_equal(dims[2], 5)
})

test_that("Plot with resamples is generated", {
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
  res <- residuals(mod, type = "working")

  ## Calculate CURE plot data
  cure_df <- calculate_cure_dataframe(AADT, res)

  ## Providing glm object
  uu <- cure_plot(mod, "LNAADT", n_resamples = 5)
  xx <- uu$data$plotcov__
  size <- length(xx)

  expect_equal(size, 900)
})

