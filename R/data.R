

#' Washington Roads
#'
#' Crashes on Washington roads from 2016, 2017, and 2018. Data acquired from Washington Department of Transportation through the Highway Safety Information System (HSIS).
#'
#' @format ## `washinton_roads`
#' A data frame with 1,501 rows and 9 columns:
#' \describe{
#'   \item{ID}{Anonimized road ID. Factor.}
#'   \item{Year}{Year. Integer.}
#'   \item{AADT}{Annual Average Daily Traffic (AADT). Double.}
#'   \item{Length}{Segment length in miles. Double.}
#'   \item{Total_crashes}{Total crashes. Positive integer.}
#'   \item{lnlength}{Natural logarithm of length in miles. Double.}
#'   \item{speed50}{Indicator of whether the speed limit is 50 mph or greater. Binary.}
#'   \item{ShouldWidth04}{Indicator of whether the shoulder is 4 feet or wider. Binary.}
#' }
#' @source <https://www.who.int/teams/global-tuberculosis-programme/data>
"washington_roads"
