#include <cstdint>
#include <ctime>

#include "libcppotp/bytes.h"
#include "libcppotp/otp.h"
#include "rstuff.h"

using namespace CppTotp;


static inline std::string normalizedBase32String(const std::string & unnorm)
{
  std::string ret;
	
  for (char c : unnorm)
  {
    if (c == ' ' || c == '\n' || c == '-')
    {
      // skip separators
    }
    else if (std::islower(c))
    {
      // make uppercase
      char u = std::toupper(c);
      ret.push_back(u);
    }
    else
    {
      ret.push_back(c);
    }
  }
	
  return ret;
}



extern "C" SEXP R_hotp(SEXP key_, SEXP counter, SEXP digits)
{
  SEXP ret;
  const char *const key = CHARPT(key_, 0);
  
  PROTECT(ret = allocVector(INTSXP, 1));
  
  std::string normalizedKey = normalizedBase32String(key);
  Bytes::ByteString qui = Bytes::fromUnpaddedBase32(normalizedKey);

  uint32_t p = hotp(qui, INTEGER(counter)[0], INTEGER(digits)[0]);
  
  INTEGER(ret)[0] = p;
  
  UNPROTECT(1);
  return ret;
}



extern "C" SEXP R_totp(SEXP key_, SEXP interval, SEXP digits)
{
  SEXP ret;
  const char *const key = CHARPT(key_, 0);
  
  PROTECT(ret = allocVector(INTSXP, 1));
  
  std::string normalizedKey = normalizedBase32String(key);
  Bytes::ByteString qui = Bytes::fromUnpaddedBase32(normalizedKey);

  uint32_t p = totp(qui, time(NULL), 0, INTEGER(interval)[0], INTEGER(digits)[0]);
  
  INTEGER(ret)[0] = p;
  
  UNPROTECT(1);
  return ret;
}
