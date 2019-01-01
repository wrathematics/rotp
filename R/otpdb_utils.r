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
