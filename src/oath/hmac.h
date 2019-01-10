#ifndef OATH_HMAC_H
#define OATH_HMAC_H

#include <stdint.h>
#include <stdlib.h>

int hmac(const void *key, size_t keylen, const void *msg, size_t msglen, uint8_t **out, size_t *outlen);

#endif
