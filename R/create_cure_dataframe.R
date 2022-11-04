#' Calculate CURE Dataframe
#'
#' @param plot_varname Variable name to be plot. With or without quotes.
#' @param dataframe A data frame that contains a variable matching \code{plot_varname} and another cone
#'
#' @return
#' @export
#'
#' @examples
calculate_cure_dataframe <- function(covariate_values, residuals){
  varname <- print(paste(substitute(covariate_values)))
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

  out |> dplyr::rename_with(~varname, variable)
}


library(ggplot2)
library(mgcv)

set.seed(2000)

n <- 300
AADT <- runif(n, min = 2000, max = 100000)
LNAADT <- log(AADT)
beta <- c(-1, 0.3)

theta <- exp(beta[1] + beta[2] * LNAADT)
beta[1]
beta[2] * LNAADT

fivenum(beta[2] * LNAADT)
fivenum(theta)

y <- rpois(n, theta)
mod <- gam(y ~ LNAADT, family = poisson)

res <- residuals(mod)
coefficients(mod)

plot(res)

anova(mod)
summary(mod)

df_cure <- calculate_cure_dataframe(AADT, res)

ggplot(df_cure) +
  geom_line(aes(x = LNAADT, y = cummres), size = 0.5, colour = "#112446") +
  geom_line(aes(x = LNAADT, y = upper), size = 0.5, colour = "red") +
  geom_line(aes(x = LNAADT, y = lower), size = 0.5, colour = "red") +
  labs(x = "LNAADT", y = "Cummulative Residuals") +
  theme_light()


ggplot(df_cure) +
  geom_line(aes(x = AADT, y = cummres), size = 0.5, colour = "#112446") +
  geom_line(aes(x = AADT, y = upper), size = 0.5, colour = "red") +
  geom_line(aes(x = AADT, y = lower), size = 0.5, colour = "red") +
  labs(x = "AADT", y = "Cummulative Residuals") +
  theme_light()
