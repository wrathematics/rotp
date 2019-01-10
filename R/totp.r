#' @useDynLib rotp R_totp
totp_wrapper = function(key, interval=30L, digits=6L)
{
  .Call(R_totp, key, interval, digits)
}



#' totp
#' 
#' Implementation of the Time-based One-Time Password algorithm.
#' 
#' @param key
#' The secret key.
#' @param interval
#' The interval of time in seconds.
#' @param digits
#' The number of digits of the return.
#' 
#' @return
#' An integer with \code{digits} digits.
#' 
#' @examples
#' rotp::totp("asdf")
#' 
#' @references \url{https://en.wikipedia.org/wiki/Time-based_One-time_Password_algorithm}
#' @export
totp = function(key, interval=30, digits=6)
{
  check.is.string(key)
  check.is.posint(interval)
  check.is.posint(digits)
  
  if (ndigits(digits) > 10)
    stop("argument 'digits' too large")
  
  interval = as.integer(interval)
  digits = as.integer(digits)
  
  totp_wrapper(key, interval, digits)
}
