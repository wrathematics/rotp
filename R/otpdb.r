#' otpdb
#' 
#' Interactive interface for the secret key database. After setting up your
#' keys using this interface, you can authenticate with \code{auth()}.
#' 
#' @details
#' The database is located at \code{~/.rotpdb}. On Windows, this will be on your
#' "My Documents" folder.
#' 
#' Secret keys are encrypted using envelope encryption. You will need an RSA key
#' which the openssl package can find. You can check for your keypair via
#' \code{openssl::my_pubkey()}.
#' 
#' @seealso \code{\link{auth}}
#' @export
otpdb = function()
{
  check.is.interactive()
  check.has.pubkey()
  
  check.db = otpdb_init()
  if (!isTRUE(check.db))
    return(invisible(FALSE))
  
  prompt = "$ "
  
  choices = c("List", "Add", "Delete", "Show", "Sort", "Reset", "Help")
  
  while (TRUE)
  {
    utils::flush.console()
    
    choice = otpdb_getchoice(choices, prompt, "Choose an operation (Q/q to quit)", long=FALSE)
    if (choice == "Q" || choice == "q")
      break
    
    choice = as.integer(choice)
    
    # ------------------------------------------------
    # List
    # ------------------------------------------------
    if (choices[choice] == "List")
    {
      err_handler({
        names = db_list()
        cat(paste("  * ", names, collapse="\n"), "\n")
      })
    }
    # ------------------------------------------------
    # Add key
    # ------------------------------------------------
    else if (choices[choice] == "Add")
    {
      name = readline("Enter a name for the key: ")
      key = getPass::getPass("Enter the key: ")
      encrypted_key = encrypt(key)
      
      err_handler(db_addkey(name, encrypted_key))
    }
    # ------------------------------------------------
    # Delete key
    # ------------------------------------------------
    else if (choices[choice] == "Delete")
    {
      test = err_handler({
        names = db_list()
      })
      if (!isTRUE(test))
        next
      
      otpdb_getchoice(names, prompt, "Pick a key to DELETE or enter Q/q to exit")
      
      if (choice == "Q" || choice == "q")
        next
      
      choice = as.integer(choice)
      name = names[choice]
      err_handler(db_delkey(name, names))
    }
    # ------------------------------------------------
    # Show key
    # ------------------------------------------------
    else if (choices[choice] == "Show")
    {
      test = err_handler({
        names = db_list()
      })
      if (!isTRUE(test))
        next
      
      msg = paste0(
"WARNING: this will show your private key in plain text. You normally do not
need to do this unless you are, for example, migrating to a different OTP
application. To authenticate with your bank or whatever, please instead use
the rotp::auth() function.

Show private key? (YES/no): ")
      check = otpdb_confirm(msg)
      if (!isTRUE(check))
        next
      
      choice = otpdb_getchoice(names, prompt, "Pick a key to SHOW or enter Q/q to exit", mask=TRUE)
      
      if (choice == "Q" || choice == "q")
        next
      
      choice = as.integer(choice)
      name = names[choice]
      
      priv_key = decrypt(db_getkey(name)$encrypted_key)
      cat(paste0("Private key: ", priv_key))
      cat("\n")
    }
    # ------------------------------------------------
    # Sort keys
    # ------------------------------------------------
    else if (choices[choice] == "Sort")
    {
      err_handler(db_sort())
    }
    # ------------------------------------------------
    # Reset
    # ------------------------------------------------
    else if (choices[choice] == "Reset")
    {
      cat("This will remove all data in the db. Are you sure?\nType 'YES' to proceed, anything else to abort\n")
      check = readline(prompt)
      if (identical(check, "YES"))
      {
        cat("Clearing database...")
        # NOTE would be amusing to add something like Sys.sleep(5) here
        db_clear()
        cat("ok!\n")
      }
      else
        cat("Reset aborted.\n")
    }
    # ------------------------------------------------
    # Help
    # ------------------------------------------------
    else if (choices[choice] == "Help")
    {
      msg = 
"1 - List
    Show all key names in the db.
2 - Add
    Add a new key to the db. You will first give it an identifiable name (e.g.
    'Bank of Blahblahblah'), and then enter the private key.
3 - Delete
    Remove a key from the db.
4 - Show
    View the private key. You should only need to do this if you are migrating
    to a different authentication application. For authenticating with your
    bank or sketchy Chinese crypto site, you should instead use the
    rotp::auth() function.
5 - Sort
    Alphabetically sort the key names.
6 - Reset
    Remove all keys from the db.
7 - Help
    This menu.
"
      
      cat(msg)
    }
    
    cat("\n")
  }
  
  invisible(TRUE)
}
