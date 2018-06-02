.onLoad <- function(libname, pkgname)
{
  if (!file.exists(db_path()))
    db_init()
  
  ### use masked reader with openssl in case ssh key is pw protected
  options(askPass=getPass::getPass)
  
  invisible()
}
