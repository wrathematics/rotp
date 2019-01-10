#include <stdint.h>

#include "rstuff.h"
#include "oath/oath.h"


SEXP R_hotp(SEXP key_, SEXP counter_, SEXP digits_)
{
  SEXP ret;
  uint32_t p;
  
  const char *const key = CHARPT(key_, 0);
  const int len = strlen(key);
  const uint32_t counter = (uint32_t) INTEGER(counter_)[0];
  const unsigned int digits = (unsigned int) INTEGER(digits_)[0];
  
  PROTECT(ret = allocVector(INTSXP, 1));
  hotp(key, len, counter, digits, &p);
  INTEGER(ret)[0] = (int) p;
  
  UNPROTECT(1);
  return ret;
}



SEXP R_totp(SEXP key_, SEXP interval_, SEXP digits_)
{
  SEXP ret;
  uint32_t p;
  
  const char *const key = CHARPT(key_, 0);
  const int len = strlen(key);
  const uint32_t interval = (uint32_t) INTEGER(interval_)[0];
  const unsigned int digits = (unsigned int) INTEGER(digits_)[0];
  
  PROTECT(ret = allocVector(INTSXP, 1));
  totp(key, len, interval, digits, &p);
  INTEGER(ret)[0] = (int) p;
  
  UNPROTECT(1);
  return ret;
}
