

#' Washington Road Crashes
#'
#' Crashes on Washington primary roads from 2016, 2017, and 2018. Data acquired
#' from Washington Department of Transportation through the Highway Safety
#' Information System (HSIS).
#'
#' @format
#' The data frame \code{washington_roads} has 1,501 rows and 9 columns:
#' \describe{
#'   \item{ID}{Anonymized road ID. Factor.}
#'   \item{Year}{Year. Integer.}
#'   \item{AADT}{Annual Average Daily Traffic (AADT). Double.}
#'   \item{Length}{Segment length in miles. Double.}
#'   \item{Total_crashes}{Total crashes. Integer.}
#'   \item{lnaadt}{Natural logarithm of AADT. Double.}
#'   \item{lnlength}{Natural logarithm of length in miles. Double.}
#'   \item{speed50}{Indicator of whether the speed limit is 50 mph or greater.
#'   Binary.}
#'   \item{ShouldWidth04}{Indicator of whether the shoulder is 4 feet or wider.
#'   Binary.}
#' }
#' @source <https://highways.dot.gov/research/safety/hsis>
"washington_roads"
