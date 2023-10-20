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
#   varname <- paste(substitute(covariate_values))
#   message("Covariate: ", varname, "\n")
#
#   ## Dummy dfns. to avoid warnings while building the package. Not actually
#   ## necessary.
#   variable <- NULL
#   residual <- NULL
#   cumres <- NULL
#   sdi <- NULL
#   sq_res <- NULL
#   sd_cure <- NULL
#
#   sd_n <- sqrt(sum(residuals^2))
#
#   out <-
#     dplyr::tibble(variable = {{covariate_values}},
#                   residual = {{residuals}}) |>
#     dplyr::arrange(variable) |>
#     dplyr::mutate(
#       cumres = cumsum(residual),
#       sq_res  = residual^2,
#       sdi = cumsum(sq_res)^0.5,
#       sd_cure = sdi * (1 - sdi^2 / sd_n^2)^0.5
#     ) |>
#     dplyr::transmute(
#       variable,
#       residual,
#       cumres,
#       lower =  -1.96 * sd_cure,
#       upper =  1.96 * sd_cure
#     )
#
#   ## Assign independent variable its original name
#   out |> dplyr::rename_with(~varname, variable)
# }
#
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
