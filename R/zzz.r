.onLoad <- function(libname, pkgname)
{
  ### use masked reader with openssl in case ssh key is pw protected
  options(askPass=getPass::getPass)
  
  invisible()
}
