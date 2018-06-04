get_time_rem = function(interval=30L)
{
  interval - (as.integer(Sys.time()) %% interval)
}



ndigits = function(n)
{
  as.integer(log10(n)) + 1L
}



hotp = function(key)
{
  
}



totp_wrapper = function(key, interval=30L, plen=6L)
{
  .Call(R_totp, key, interval, plen)
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
#' @param plen
#' TODO
#' 
#' @return
#' An integer with \code{plen} digits.
#' 
#' @examples
#' library(rotp)
#' 
#' totp("asdf")
#' totp("asdf, interval=15, plen=3")
#' 
#' @export
totp = function(key, interval=30L, plen=6L)
{
  check.is.string(key)
  check.is.posint(interval)
  check.is.posint(plen)
  
  if (ndigits(plen) > 10)
    stop("plen too large")
  
  interval = as.integer(interval)
  plen = as.integer(plen)
  
  totp_wrapper(key, interval, plen)
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
