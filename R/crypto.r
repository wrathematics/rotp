encrypt = function(key)
{
  val_to_raw(openssl::encrypt_envelope(charToRaw(key)))
}

decrypt = function(encrypted_key)
{
  e = raw_to_val(encrypted_key)
  rawToChar(openssl::decrypt_envelope(data=e$data, iv=e$iv, session=e$session))
}
