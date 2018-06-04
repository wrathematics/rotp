/* Automatically generated. Do not edit by hand. */

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <stdlib.h>

extern SEXP R_totp(SEXP key_, SEXP interval, SEXP plen);

static const R_CallMethodDef CallEntries[] = {
  {"R_totp", (DL_FUNC) &R_totp, 3},
  {NULL, NULL, 0}
};

void R_init_rotp(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
