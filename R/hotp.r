hotp_wrapper = function(key, counter, digits=6L)
{
  .Call(R_hotp, key, counter, digits)
}



#' hotp
#' 
#' Implementation of the HMAC-based One-Time Password algorithm.
#' 
#' @param key
#' The secret key.
#' @param counter
#' A "counter" (some integer).
#' @param digits
#' The number of digits of the return.
#' 
#' @return
#' An integer with \code{digits} digits.
#' 
#' @examples
#' rotp::totp("asdf", 10)
#' 
#' @references \url{https://en.wikipedia.org/wiki/HMAC-based_One-time_Password_algorithm}
#' @export
hotp = function(key, counter, digits=6)
{
  check.is.string(key)
  check.is.inty(counter)
  check.is.posint(digits)
  
  if (ndigits(digits) > 10)
    stop("argument 'digits' too large")
  
  counter = as.integer(counter)
  digits = as.integer(digits)
  
  hotp_wrapper(key, counter, digits)
}
