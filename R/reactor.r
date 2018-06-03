is.badval = function(x)
{
  is.na(x) || is.nan(x) || is.infinite(x)
}

is.inty = function(x)
{
  abs(x - round(x)) < 1e-10
}

is.zero = function(x)
{
  abs(x) < 1e-10
}

is.negative = function(x)
{
  x < 0
}

is.annoying = function(x)
{
  length(x) != 1 || is.badval(x)
}

is.string = function(x)
{
  is.character(x) && !is.annoying(x)
}

is.flag = function(x)
{
  is.logical(x) && !is.annoying(x)
}



check.is.string = function(x)
{
  if (!is.string(x))  
	{
    nm = deparse(substitute(x))
    stop(paste0("argument '", nm, "' must be a single string"), call.=FALSE)
  }
	
  invisible(TRUE)
}

check.is.flag = function(x)
{
  if (!is.flag(x))
  {
    nm = deparse(substitute(x))
    stop(paste0("argument '", nm, "' must be TRUE or FALSE"), call.=FALSE)
  }
  
  invisible(TRUE)
}

check.is.interactive = function()
{
  if (!isTRUE(interactive()))
    stop("this can only be used interactively")
  
  invisible(TRUE)
}

check.has.pubkey = function()
{
  pubkey_test = tryCatch(openssl::my_pubkey(), error=identity)
  if (inherits(pubkey_test, "simpleError"))
    stop("no valid ")
  
  invisible(TRUE)
}
