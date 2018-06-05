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
#' Interactive authenticator interface.
#' 
#' @details
#' TODO
#' 
#' @export
auth = function()
{
  check.is.interactive()
  check.has.pubkey()
  
  prompt = "$ "
  
  if (db_len() == 0)
    stop("No keys stored in db! Add some by first running rundb()\n")
  else
    names = db_list()
  
  choices_verbose = names
  choices = 1:length(choices_verbose)
  
  utils::flush.console()
  cat("Pick a key or enter Q/q to exit:\n")
  cat(" ", paste(choices, choices_verbose, sep=" - ", collapse="\n  "), "\n")
  
  choice = getPass::getPass(prompt)
  
  while (choice != "Q" && choice != "q" && all(choice != choices))
  {
    cat("ERROR: please choose one of", paste(choices, collapse=", "), "\n")
    choice = readline(prompt)
  }
  
  if (choice == "Q" || choice == "q")
    return(invisible())
  
  choice = as.integer(choice)
  name = choices_verbose[choice]
  key = decrypt(db_getkey(name)$encrypted_key)
  auth_from_key(key)
  
  invisible(NULL)
}
