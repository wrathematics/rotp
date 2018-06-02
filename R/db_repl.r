err_handler = function(expr)
{
  test = tryCatch(eval({expr}, envir=-1), error=identity)
  if (inherits(test, "simpleError"))
  {
    cat(paste("ERROR:", test$message), "\n")
    FALSE
  }
  else
    TRUE
}



#' rundb
#' 
#' Interactive interface for the secret key database.
#' 
#' @details
#' TODO
#' 
#' @export
rundb = function()
{
  check.is.interactive()
  
  prompt = "$ "
  
  choices_verbose = c("List", "Add key", "Delete key", "Sort keys", "Reset")
  choices = 1:length(choices_verbose)
  
  while (TRUE)
  {
    utils::flush.console()
    cat("Choose an operation (Q/q to quit):\n")
    cat(" ", paste(choices, choices_verbose, sep=" - ", collapse="    "), "\n")
    
    choice = readline(prompt)
    
    if (choice == "q" || choice == "Q")
      break
    
    while (all(choice != choices))
    {
      cat("ERROR: please choose one of", paste(choices, collapse=", "), "\n")
      choice = readline(prompt)
    }
    
    choice = as.integer(choice)
    
    # ------------------------------------------------
    # List
    # ------------------------------------------------
    if (choices_verbose[choice] == "List")
    {
      err_handler({
        names = db_list()
        cat(paste("  * ", names, collapse="\n"), "\n")
      })
    }
    # ------------------------------------------------
    # Add key
    # ------------------------------------------------
    else if (choices_verbose[choice] == "Add key")
    {
      name = readline("Enter a name for the key: ")
      key = getPass::getPass("Enter the key: ")
      encrypted_key = encrypt(key)
      
      err_handler(db_addkey(name, encrypted_key))
    }
    # ------------------------------------------------
    # Delete key
    # ------------------------------------------------
    else if (choices_verbose[choice] == "Delete key")
    {
      test = err_handler({
        names = db_list()
      })
      if (!isTRUE(test))
        next
      
      choices_names_verbose = names
      choices_names = 1:length(choices_names_verbose)
      
      cat("Pick a key to DELETE or enter Q/q to exit:\n")
      cat(" ", paste(choices_names, choices_names_verbose, sep=" - ", collapse="\n  "), "\n")
      
      choice = readline(prompt)
      while (choice != "Q" && choice != "q" && all(choice != choices_names))
      {
        cat("ERROR: please choose one of", paste(choices_names, collapse=", "), "\n")
        choice = readline(prompt)
      }
      
      if (choice == "Q" || choice == "q")
        return(invisible())
      
      choice = as.integer(choice)
      name = names[choice]
      err_handler(db_delkey(name, names))
    }
    # ------------------------------------------------
    # Sort keys
    # ------------------------------------------------
    else if (choices_verbose[choice] == "Sort keys")
    {
      err_handler(db_sort())
    }
    # ------------------------------------------------
    # Reset
    # ------------------------------------------------
    else if (choices_verbose[choice] == "Reset")
    {
      cat("This will remove all data in the db. Are you sure?\nType 'YES' to proceed, anything else to abort\n")
      sure = readline(prompt)
      if (identical(sure, "YES"))
      {
        cat("Clearing database...")
        # would be amusing to add something like Sys.sleep(5) here
        db_clear()
        cat("ok!\n")
      }
      else
        cat("Reset aborted.\n")
    }
    
    cat("\n")
  }
}
