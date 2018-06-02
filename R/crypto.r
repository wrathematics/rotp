encrypt = function(key)
{
  serialize(openssl::encrypt_envelope(charToRaw(key)), NULL)
}

decrypt = function(encrypted_key)
{
  e = unserialize(encrypted_key)
  rawToChar(openssl::decrypt_envelope(data=e$data, iv=e$iv, session=e$session))
}
