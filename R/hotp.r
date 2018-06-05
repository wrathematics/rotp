hotp_wrapper = function(key, counter, digits=6L)
{
  .Call(R_hotp, key, counter, digits)
}



#' hotp
#' 
#' TODO
#' 
#' @details
#' TODO sha1 etc
#' 
#' @param key
#' TODO
#' @param counter
#' TODO
#' @param digits
#' TODO
#' 
#' @return
#' An integer with \code{digits} digits.
#' 
#' @examples
#' library(rotp)
#' totp("asdf", 10, digits=8)
#' 
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
