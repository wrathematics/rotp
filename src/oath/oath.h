#ifndef OATH_H
#define OATH_H

#include <stdint.h>
#include <time.h>

#define OTP_RETURN_OK 0
#define OTP_RETURN_OOM 1
#define OTP_RETURN_OTHER 2

int hotp(const char *secret, const int len, const uint32_t counter, unsigned int digits, uint32_t *num);
int totp(const char *secret, const int len, const uint32_t interval, unsigned int digits, uint32_t *num);

#endif
