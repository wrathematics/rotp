AC_PREREQ([2.69])
AC_INIT(DESCRIPTION)

# Get C compiler from R
: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
  echo "could not determine R_HOME"
  exit 1
fi
CC=`"${R_HOME}/bin/R" CMD config CC`
CFLAGS=`"${R_HOME}/bin/R" CMD config CFLAGS`
CPPFLAGS=`"${R_HOME}/bin/R" CMD config CPPFLAGS`
LDFLAGS=`"${R_HOME}/bin/R" CMD config LDFLAGS`


AC_PROG_CC
AC_PROG_CC_C99



# 1=big endian, 0=little endian
AC_C_BIGENDIAN([ENDIANNESS=1], [ENDIANNESS=0], 
  [AC_MSG_ERROR([unable to determine endianness; not dealing with you])]
)

if test "X${ENDIANNESS}" = "X1"; then
  BOBE_REPORT="byte order: big endian"
else
  BOBE_REPORT="byte order: little endian"
fi



AX_CHECK_OPENSSL()


AC_SUBST(ENDIANNESS)
AC_OUTPUT(src/oath/endianness.h)

AC_SUBST(OPENSSL_INCLUDES)
AC_SUBST(OPENSSL_LDFLAGS)
AC_OUTPUT(src/Makevars)
