get_key_path = function()
{
  home_path = get_home_path()
  paste0(home_path, "/.ssh/")
}



#' @useDynLib rotp R_create_rsa_keys
create_rsa_keys = function(path)
{
  path = path.expand(path)
  
  if (!dir.exists(path))
    dir.create(path, recursive=TRUE)
  
  .Call(R_create_rsa_keys, path)
}



setup_keys = function()
{
  path = get_key_path()
  path_pub = paste0(path, "/id_rsa.pub")
  path_priv = paste0(path, "/id_rsa")
  
  if (file.exists(path_priv))
    return(FALSE)
  
  create_rsa_keys(path)
  
  TRUE
}



setup = function()
{
  cat("Setting up RSA keys...")
  check = setup_keys()
  if (check)
    cat("done!\n")
  else
    cat("keys already exist; skipping\n")
  
  
  cat("Setting up otp key database...")
  check = otpdb_init()
  if (check)
    cat("done!\n")
  else
    cat("key database already exists; skipping\n")
}
