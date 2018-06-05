get_time_rem = function(interval=30L)
{
  interval - (as.integer(Sys.time()) %% interval)
}



ndigits = function(n)
{
  as.integer(log10(n)) + 1L
}



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
#' 
#' totp("asdf", 10, digits=3L)
#' 
#' @export
hotp = function(key, counter, digits=6L)
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
#' totp("asdf, interval=15, digits=3")
#' 
#' @export
totp = function(key, interval=30L, digits=6L)
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



progress_bar = function(rem, chars=30L, interval=30L)
{
  n_empty = as.integer(rem/interval*chars)
  n_full = chars - n_empty
  
  paste0(
    "[",
    paste0(rep("=", n_full), collapse=""),
    paste0(rep("-", n_empty), collapse=""),
    "]",
    collapse=""
  )
}


auth = function(name)
{
  check.is.string(name)
  
  key = decrypt(db_getkey(name)$encrypted_key)
  cat("Ctrl+c to exit\n")
  
  while (TRUE)
  {
    rem = get_time_rem()
    p = totp_wrapper(key)
    p_str = sprintf("%06d", p)
    
    while (rem > 0)
    {
      cat('\r', paste0(p_str, " (", sprintf("%2d", rem), " seconds remaining ", progress_bar(rem), ") "))
      utils::flush.console()
      rem = rem - 1L
      Sys.sleep(1)
    }
  }
  
  rm(key)
  invisible(gc(verbose=FALSE, reset=TRUE))
  
  invisible(NULL)
}
