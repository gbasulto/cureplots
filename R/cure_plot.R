#' CURE Plot
#'
#' @param x Either a data frame produced with
#'   \link{\code{create_cure_dataframe}}, in that case, the first column is used
#'   to produce CURE plot; or a \link{\code{glm}} object.
#' @param covariate Required when \code{x} is a \link{\code{glm}} object.
#'
#' @return A \link{\code{ggplot2}} object of a CURE plot.
#' @export
#'
#' @examples
#' ## basic example code
#'
#' set.seed(2000)
#'
#' #'#' Define parameters
#' beta <- c(-1, 0.3, 3)
#'
#' #'#' Simulate idependent variables
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
#'
#' ## Providing CURE data frame
#' cure_plot(cure_df)
#'
#' ## Providing glm object
#' cure_plot(mod, "LNAADT")
cure_plot <- function(x, covariate = NULL) {



  ## Messages
  msg <- c(
    df_provided = paste0("CURE data frame was provided. Its first column, ",
                         "{cov_name}, will be used.\n"))


  if (is.data.frame(x)) {
    cov_name <- names(x)[1]

    ## Display message
    message(glue::glue(msg[1]))

    ## Create copy
    plot_df <- x

    ## Case when a model is provided
  } else {
    cov_name <- covariate
    plotcov__ <- mod[["model"]][[covariate]]
    residuals <- residuals(mod)
    plot_df <- suppressMessages(
      calculate_cure_dataframe(plotcov__, residuals)
    )
  }

  ## Rename first column
  names(plot_df) <- c("plotcov__", names(plot_df)[-1])

  plot_df |>
    ggplot2::ggplot() +
    ggplot2::aes(x = plotcov__) +
    ggplot2::geom_line(aes(y = cumres), linewidth = 0.9,
                       color = "#112446") +
    ggplot2::geom_line(
      ggplot2::aes(y = upper), linewidth = 0.75, color = "red") +
    ggplot2::geom_line(
      ggplot2::aes(y = lower), linewidth = 0.75, color = "red") +
    ggplot2::labs(x = cov_name, y = "Cumulative Residuals") +
    ggplot2::theme_light()
}

