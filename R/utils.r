get_remaining_time = function(interval=30L)
{
  interval - (as.integer(Sys.time()) %% interval)
}



ndigits = function(n)
{
  as.integer(log10(n)) + 1L
}



progress_bar = function(rem, chars=30L, interval=30L)
{
  n_empty = as.integer(rem/interval*chars)
  n_full = chars - n_empty
  
  paste0(
    "[",
    paste0(rep("=", n_full), collapse=""),
    paste0(rep("-", n_empty), collapse=""),
    "]",
    collapse=""
  )
}
