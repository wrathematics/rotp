#' runauth
#' 
#' Interactive authenticator interface.
#' 
#' @details
#' TODO
#' 
#' @export
runauth = function()
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
  
  cat("\n")
  auth(choices_verbose[choice])
  
  invisible(NULL)
}
