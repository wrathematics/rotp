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



otpdb_confirm = function(msg)
{
  cat(msg)
  choice = readline()
  
  if (choice == "YES")
    TRUE
  else
    FALSE
}



otpdb_init = function()
{
  db = path.expand(db_path())
  if (file.exists(db))
    TRUE
  else
  {
    msg = paste0(
"To use the package, we need to create a persistent key database file. This file
will be located at the path \"", db, "\".

To proceed, enter YES (all caps). Entering anything else will halt the
application.

Create db file? (YES/no): ")
    check = otpdb_confirm(msg)
    
    if (isTRUE(check))
      db_init()
    
    check
  }
}



otpdb_getchoice = function(choices, prompt, msg, long=TRUE)
{
  choices_number = 1:length(choices)
  
  if (long)
    asdf = "\n  "
  else
    asdf = "   "
  
  cat(paste0(msg, ":\n"))
  cat(" ", paste(choices_number, choices, sep=" - ", collapse=asdf), "\n")
  
  choice = readline(prompt)
  while (choice != "Q" && choice != "q" && all(choice != choices_number))
  {
    cat("ERROR: please choose one of", paste(choices_number, collapse=", "), "\n")
    choice = readline(prompt)
  }
  
  choice
}
