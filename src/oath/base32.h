#ifndef BASE32_H
#define BASE32_H

#include <stdint.h>

int base32_decode(const char *enc, uint8_t *res, int len);

#endif
