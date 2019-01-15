/* Automatically generated. Do not edit by hand. */

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <stdlib.h>

extern SEXP R_hotp(SEXP key_, SEXP counter, SEXP digits);
extern SEXP R_totp(SEXP key_, SEXP interval, SEXP digits);
extern SEXP R_create_rsa_keys(SEXP path_);

static const R_CallMethodDef CallEntries[] = {
  {"R_hotp", (DL_FUNC) &R_hotp, 3},
  {"R_totp", (DL_FUNC) &R_totp, 3},
  {"R_create_rsa_keys", (DL_FUNC) &R_create_rsa_keys, 1},
  {NULL, NULL, 0}
};

void R_init_rotp(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
