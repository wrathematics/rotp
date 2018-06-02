get_time_rem = function(interval=30L)
{
  interval - (as.integer(Sys.time()) %% interval)
}



totp = function(key)
{
  .Call(R_totp, key)
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
    p = totp(key)
    p_str = sprintf("%06d", p)
    
    while (rem > 0)
    {
      # cat('\r', paste0(p_str, " (", rem, " seconds remaining) "))
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
