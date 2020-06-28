db_path = function()
{
  home_path = get_home_path()
  paste0(home_path, ".rotpdb")
}



db_init = function()
{
  cat("", file=db_path(), append=FALSE)
}



db_len = function()
{
  file.info(db_path())$size
}



db_check = function()
{
  if (db_len() == 0)
    stop("no keys stored in db")
}



db_clear = function()
{
  db = db_path()
  if (file.exists(db))
    file.remove(db)
  
  db_init()
}



db_read = function()
{
  readBin(db_path(), what="raw", n=db_len())
}



db_write = function(data, overwrite=FALSE)
{
  if (isTRUE(overwrite))
    db_clear()
  else
    data = c(db_read(), data)
  
  writeBin(data, db_path())
}



db_encode = function(name, encrypted_key)
{
  name_enc = val_to_raw(name)
  encrypted_key_enc = val_to_raw(encrypted_key)
  
  c(
    val_to_raw(length(name_enc)),
    name_enc,
    val_to_raw(length(encrypted_key_enc)),
    encrypted_key_enc
  )
}



db_decode = function(data, start)
{
  DIGIT_LENGTH = 26L
  
  offset = start+DIGIT_LENGTH
  name_len = raw_to_val(data, start, offset-1L)
  name = raw_to_val(data, offset, offset + name_len - 1L)
  
  offset = offset + name_len
  encrypted_key_len = raw_to_val(data, offset, offset + DIGIT_LENGTH - 1L)
  last = offset + DIGIT_LENGTH + encrypted_key_len - 1L
  encrypted_key = raw_to_val(data, offset+DIGIT_LENGTH, last)
  
  list(name=name, encrypted_key=encrypted_key, last=last)
}



db_list = function()
{
  db_check()
  
  data = db_read()
  names = c()
  
  n = db_len()
  start = 1L
  
  while (start < n)
  {
    record = db_decode(data, start=start)
    names = c(names, record$name)
    start = record$last + 1L
  }
  
  names
}



db_addkey = function(name, encrypted_key)
{
  if (db_len() > 0)
  {
    names = db_list()
    if (any(name == names))
      stop("duplicate name entry")
  }
  
  data = db_encode(name, encrypted_key)
  db_write(data)
}



db_delkey = function(name, names)
{
  if (all(name != names))
    stop("name entry not found")
  else if (length(names) == 1)
    return(db_clear())
  
  data = db_read()
  
  n = db_len()
  start = 1L
  
  while (start < n)
  {
    record = db_decode(data, start=start)
    if (record$name == name)
    {
      data = data[-(start:record$last)]
      break
    }
    
    start = record$last + 1L
  }
  
  db_write(data, overwrite=TRUE)
}



db_getkey = function(name)
{
  names = db_list()
  if (all(name != names))
    stop("name entry not found")
  else if (length(names) == 1)
    return(db_decode(db_read(), start=1L))
  
  data = db_read()
  
  n = db_len()
  start = 1L
  
  while (start < n)
  {
    record = db_decode(data, start=start)
    if (name == record$name)
      return(record)
    
    start = record$last + 1L
  }
}



db_sort = function()
{
  db_check()
  
  data = db_read()
  names = c()
  records = list()
  
  n = db_len()
  start = 1L
  i = 1L
  
  while (start < n)
  {
    record = db_decode(data, start=start)
    names = c(names, record$name)
    records[[i]] = data[start:record$last]
    start = record$last + 1L
    i = i + 1L
  }
  
  records = records[order(names)]
  data = do.call(c, records)
  
  db_write(data, overwrite=TRUE)
}
