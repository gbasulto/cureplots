

#' Washington Road Crashes
#'
#' Crashes on Washington primary roads from 2016, 2017, and 2018. Data acquired
#' from Washington Department of Transportation through the Highway Safety
#' Information System (HSIS).
#'
#' @format
#' `washinton_roads` is a data frame with 1,501 rows and 9 columns:
#' \describe{
#'   \item{ID}{Anonimized road ID. Factor.}
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
#' @source \url{https://www.hsisinfo.org/}
"washington_roads"
