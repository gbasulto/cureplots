#' CURE Plot
#'
#' @param x Either a data frame produced with
#'   \code{\link{calculate_cure_dataframe}}, in that case, the first column is
#'   used to produce CURE plot; or regression model for count data (e.g.,
#'   Poisson) adjusted with \code{\link[stats]{glm}} or \code{\link[mgcv]{gam}}.
#' @param covariate Required when \code{x} is model fit.
#' @param n_resamples Number of resamples to overlay on CURE plot. Zero is the
#'   default.
#'
#' @return A CURE plot generated with \pkg{ggplot2}.
#' @export
#'
#' @examples
#' ## basic example code
#'
#' set.seed(2000)
#'
#' ## Define parameters
#' beta <- c(-1, 0.3, 3)
#'
#' ## Simulate independent variables
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
#' res <- residuals(mod, type = "response")
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
#'
#' ## Providing glm object adding resamples cumulative residuals
#' cure_plot(mod, "LNAADT", n_resamples = 3)
cure_plot <- function(x, covariate = NULL, n_resamples = 0) {

  ## Dummy dfns. to avoid warnings while building the package. Not actually
  ## necessary.
  cumres <- NULL
  upper <- NULL
  lower <- NULL


  ## Messages
  msg <- c(
    df_provided = paste0("CURE data frame was provided. Its first column, ",
                         "{cov_name}, will be used.\n"),
    ignore_covariate =
      paste0("Argument covariate = {covariate} will be ignored.\n"),
    missing_covariate =
      paste0("Argument 'covariate' must be provided along with model\n"),
    model_provided =
      paste0("Covariate {covariate} will be used to produce CURE plot.\n")
    )


  ## Check if a data frame or model was received.
  if (is.data.frame(x)) {
    cov_name <- names(x)[1]

    ## Display message
    message(glue::glue(msg[1]))
    if (!is.null(covariate)) message(glue::glue(msg[2]))

    ## Create copy
    plot_df <- x

    ## Copy covariate values
    plotcov__ <- plot_df[[cov_name]]
    residuals <- plot_df[["residual"]]

    ## Case when a model is provided
  } else {

    ## Covariate messages
    if (is.null(covariate)) {
      stop(glue::glue(msg[3]))
    } else {
      message(glue::glue(msg[4]))
    }

    ## Extract covariate and residuals
    cov_name <- covariate
    plotcov__ <- x[["model"]][[covariate]]
    residuals <- residuals(x, type = "response")

    ## Save plot
    plot_df <- suppressMessages(
      calculate_cure_dataframe(plotcov__, residuals)
    )
  }

  ## Rename first column
  names(plot_df) <- c("plotcov__", names(plot_df)[-1])

  ## Create base for ggplot2 object
  out <-
    plot_df |>
    ggplot2::ggplot() +
    ggplot2::aes(x = plotcov__)

  ## Produce resamples (if required) and add them to ggplot2 object.
  if (n_resamples > 0) {

    ## Resample residuals
    resamples_tbl <-
      resample_residuals(plotcov__, residuals, n_resamples)

    ## Add overlay resamples to plot
    out <-
      out +
      ggplot2::geom_line(
        data = resamples_tbl,
        ggplot2::aes(x = plotcov__, y = cumres, group = sample),
        col = "grey"
      )
  }

  out +
    ggplot2::geom_line(
      ggplot2::aes(y = cumres), linewidth = 0.9, color = "#112446") +
    ggplot2::geom_line(
      ggplot2::aes(y = upper), linewidth = 0.75, color = "red") +
    ggplot2::geom_line(
      ggplot2::aes(y = lower), linewidth = 0.75, color = "red") +
    ggplot2::labs(x = cov_name, y = "Cumulative Residuals") +
    ggplot2::theme_light()
}

