#ifndef rstuff_h
#define rstuff_h

#ifdef __cplusplus
extern "C" {
#endif

// ----------------------------------------------------------------------------

#include <R.h>
#include <Rinternals.h>

#define CHARPT(x,i) ((char*)CHAR(STRING_ELT(x,i)))

// ----------------------------------------------------------------------------
#ifdef __cplusplus
}
#endif

#endif
