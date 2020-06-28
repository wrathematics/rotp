val_to_raw = function(x)
{
  serialize(x, NULL, version=2)
}

raw_to_val = function(x, start, stop)
{
  if (missing(start) && missing(stop))
    unserialize(x)
  else if (!missing(start) && missing(stop))
    unserialize(x[start:length(x)])
  else if (missing(start) && !missing(stop))
    unserialize(x[1:stop])
  else
    unserialize(x[start:stop])
}
