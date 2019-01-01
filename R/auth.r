auth_from_key = function(key)
{
  cat("\nCtrl+c to exit\n")
  
  while (TRUE)
  {
    rem = get_remaining_time()
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



#' auth
#' 
#' Interactive authenticator interface. Similar in scope to Google
#' Authenticator. To use, you must first set up your database of keys
#' using \code{otpdb()}.
#' 
#' @details
#' Only the requested database key will be decrypted in memory. Keys are never
#' decrypted on disk.
#' 
#' @seealso \code{\link{otpdb}}
#' @references \url{https://en.wikipedia.org/wiki/Google_Authenticator}
#' @export
auth = function()
{
  check.is.interactive()
  check.has.pubkey()
  
  prompt = "$ "
  
  if (!file.exists(db_path()) || db_len() == 0)
    stop("No keys stored in db! Add some by first running otpdb()\n")
  else
    choices = db_list()
  
  
  utils::flush.console()
  
  choice = otpdb_getchoice(choices, prompt, "Pick a key or enter Q/q to exit", use_getPass=TRUE)
  if (choice == "Q" || choice == "q")
    return(invisible())
  
  name = choices[choice]
  key = decrypt(db_getkey(name)$encrypted_key)
  auth_from_key(key)
  
  invisible(NULL)
}
