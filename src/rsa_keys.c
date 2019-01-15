#include <openssl/pem.h>
#include <openssl/rsa.h>

#include <Rinternals.h>
#include <string.h>


#define CHARPT(x,i) ((char*)CHAR(STRING_ELT(x,i)))

#define BITS 4096

#define OPENSSL_FAILURE 0
#define OPENSSL_SUCCESS 1
#define CHECKRET(ret) if (ret == OPENSSL_FAILURE){goto cleanup;}


#define PATHLEN 512
char path[PATHLEN];



static inline void reset_path()
{
  for (int i=0; i<PATHLEN; i++)
    path[i] = '\0';
}


static inline void set_path(const char *const restrict keypath, const char *const restrict file)
{
  const int keypath_len = strlen(keypath);
  const int file_len = strlen(file);
  
  if (keypath_len + file_len >= PATHLEN)
    error("file path too long\n");
  
  for (int i=0; i<keypath_len; i++)
    path[i] = keypath[i];
  
  for (int i=0; i<file_len; i++)
    path[keypath_len + i] = file[i];
}



int generate_key(const char *keypath)
{
  int ret;
  RSA *key = NULL;
  BIGNUM *bignum = NULL;
  BIO *bio_public = NULL;
  BIO *bio_private = NULL;
  unsigned long w = RSA_F4;
  
  
  // generate
  bignum = BN_new();
  ret = BN_set_word(bignum, w);
  CHECKRET(ret);
  
  key = RSA_new();
  ret = RSA_generate_key_ex(key, BITS, bignum, NULL);
  CHECKRET(ret);
  
  
  // save keys
  reset_path();
  set_path(keypath, "id_rsa.pub");
  bio_public = BIO_new_file(path, "w+");
  ret = PEM_write_bio_RSAPublicKey(bio_public, key);
  CHECKRET(ret);
  
  reset_path();
  set_path(keypath, "id_rsa");
  bio_private = BIO_new_file(path, "w+");
  ret = PEM_write_bio_RSAPrivateKey(bio_private, key, NULL, NULL, 0, NULL, NULL);
  
  
cleanup:
  reset_path();
  BIO_free_all(bio_public);
  BIO_free_all(bio_private);
  RSA_free(key);
  BN_free(bignum);
  
  return ret == OPENSSL_SUCCESS;
}



SEXP R_create_rsa_keys(SEXP keypath_)
{
  SEXP ret;
  const char *keypath = CHARPT(keypath_, 0);
  
  PROTECT(ret = allocVector(LGLSXP, 1));
  LOGICAL(ret)[0] = generate_key(keypath);
  
  UNPROTECT(1);
  return ret;
}
