#
# library(cureplots)
#
# ## basic example
#
# set.seed(2000)
#
# ## Define parameters.
# beta <- c(-1, 0.3, 3)
#
# ## Simulate idependent variables
# n <- 900
# AADT <- c(runif(n, min = 2000, max = 150000))
# nlanes <- sample(x = c(2, 3, 4), size = n, replace = TRUE)
# LNAADT <- log(AADT)
#
# ## Simulate dependent variable
# theta <- exp(beta[1] + beta[2] * LNAADT + beta[3] * nlanes)
# y <- rpois(n, theta)
#
# ## Fit model
# mod <- glm(y ~ LNAADT + nlanes, family = poisson)
#
# ## Calculate residuals
# res <- residuals(mod, type = "working")
#
# ## Calculate CURE plot data
# cure_df <- calculate_cure_dataframe(AADT, res)
#
# resample_residuals <- function(covariate_values, residuals, n_resamples){
#
#   idx <- 1:n_resamples
#
#   out_list <-
#     lapply(idx,
#            \(x) calculate_cure_dataframe(covariate_values, residuals) |>
#              transform(sample = idx))
#
#   do.call("rbind", out_list)
# }
#
# resampled_residuals_tbl <- resample_residuals(AADT, res, n_resamples = 3)
#
# resampled_residuals_tbl |>
#   cbind(deparse.level = 2)
#
# n_resamples <- 3
#
# library(tidyverse)
#
# if (n_resamples > 0) {
#   resamples_tbl <-
#     1:n_resamples |>
#     map_df(\(x)
#            calculate_cure_dataframe(AADT, sample(res)) |>
#              transmute(resample = x, AADT, cumres)
#     )
# }
#
#
# cure_plot(cure_df) +
#   geom_line(data = resamples_tbl, aes(x= AADT, y = cumres, group = resample), color = "grey")
