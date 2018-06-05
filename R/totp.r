totp_wrapper = function(key, interval=30L, digits=6L)
{
  .Call(R_totp, key, interval, digits)
}



#' totp
#' 
#' TODO
#' 
#' @details
#' TODO sha1 etc
#' 
#' @param key
#' TODO
#' @param interval
#' TODO
#' @param digits
#' TODO
#' 
#' @return
#' An integer with \code{digits} digits.
#' 
#' @examples
#' library(rotp)
#' 
#' totp("asdf")
#' totp("asdf", interval=15, digits=8)
#' 
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
