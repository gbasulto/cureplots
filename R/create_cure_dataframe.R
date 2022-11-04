#' Calculate CURE Dataframe
#'
#' @param covariate_values name to be plot. With or without quotes.
#' @param residuals Residuals.
#'
#' @return A data frame with five columns: independent variable, residuals,
#'   cummulative residuals, lower confidence interval limit, and upper
#'   confidence interval limit.
#' @export
#'
#' @examples
#' set.seed(2000)
#'
#' ## Define parameters
#' beta <- c(-1, 0.3, 3)
#'
#' ## Simulate idependent variables
#' n <- 900
#' AADT <- c(runif(n, min = 2000, max = 150000))
#' nlanes <- sample(x = c(2, 3, 4), size = n, replace = TRUE)
#' LNAADT <- log(AADT)
#'
#' ## Simulate dependent variable
#' theta <- exp(beta[1] + beta[2] * LNAADT + beta[3] * nlanes)
#' y <- rpois(n, theta)
#'
#' ## Fit model
#' mod <- glm(y ~ LNAADT + nlanes, family = poisson)
#'
#' ## Calculate residuals
#' res <- residuals(mod)
#'
#' ## Calculate CURE plot data
#' cure_df <- calculate_cure_dataframe(AADT, res)
#'
#' head(cure_df)
calculate_cure_dataframe <- function(covariate_values, residuals){
  varname <- paste(substitute(covariate_values))
  cat("Covariate = ", varname, "\n")

  sd_n <- sqrt(sum(residuals^2))

  out <-
    dplyr::tibble(variable = {{covariate_values}},
                  residual = {{residuals}}) |>
    dplyr::arrange(variable) |>
    dplyr::mutate(
      cummres = cumsum(residual),
      sq_res  = residual^2,
      sdi = cumsum(sq_res)^0.5,
      sd_cure = sdi * (1 - sdi^2 / sd_n^2)^0.5
    ) |>
    dplyr::transmute(
      variable,
      residual,
      cummres,
      lower =  -1.96 * sd_cure,
      upper =  1.96 * sd_cure
    )

  ## Assign independent variable its original name
  out |> dplyr::rename_with(~varname, variable)
}



#
# library(ggplot2)
# library(mgcv)
#
# set.seed(2000)
#
# n <- 900
# AADT <- c(runif(n, min = 2000, max = 150000))
# nlanes <- sample(x = c(2, 3, 4), size = n, replace = TRUE)
# LNAADT <- log(AADT)
# beta <- c(-1, 0.3, 3)
#
# theta <- exp(beta[1] + beta[2] * LNAADT + beta[3] * nlanes)
# beta[1]
# beta[2] * LNAADT
#
# fivenum(beta[2] * LNAADT)
# fivenum(theta)
#
# y <- rpois(n, theta)
# mod <- glm(y ~ LNAADT + nlanes, family = poisson)
#
# res <- residuals(mod)
# coefficients(mod)
#
# plot(res)
#
# anova(mod)
# summary(mod)
#
# df_cure <- calculate_cure_dataframe(AADT, res)
#
# calculate_cure_dataframe(LNAADT, res) |>
#   ggplot() +
#   geom_line(aes(x = LNAADT, y = cummres), size = 0.5, colour = "#112446") +
#   geom_line(aes(x = LNAADT, y = upper), size = 0.5, colour = "red") +
#   geom_line(aes(x = LNAADT, y = lower), size = 0.5, colour = "red") +
#   labs(x = "LNAADT", y = "Cummulative Residuals") +
#   theme_light()
#
#
# calculate_cure_dataframe(AADT, res) |>
#   ggplot() +
#   geom_line(aes(x = AADT, y = cummres), size = 0.5, colour = "#112446") +
#   geom_line(aes(x = AADT, y = upper), size = 0.5, colour = "red") +
#   geom_line(aes(x = AADT, y = lower), size = 0.5, colour = "red") +
#   labs(x = "AADT", y = "Cummulative Residuals") +
#   theme_light()
