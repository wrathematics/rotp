#include <stdlib.h>

#include "base32.h"
#include "hmac.h"
#include "oath.h"
#include "os.h"

#if OS_WINDOWS
	#include <Winsock2.h>
	#include "windows/endianness.h"
#else
	#include <arpa/inet.h>
	#include "endianness.h"
#endif

static inline uint32_t code_trunc(uint8_t *md, size_t dlen, int digits){
	int i;
	uint32_t base = 1;
	uint32_t off = md[dlen-1]&0xf;
	uint32_t t;

	for(i=0;i<digits;i++)
		base *= 10;

	t = (md[off+0]&0x7f) << 24;
	t |= (md[off+1]) << 16;
	t |= (md[off+2]) << 8;
	t |= (md[off+3]);

	return t % base;
}

static inline int otp(uint8_t *key, int keylen, unsigned int digits, uint64_t counter, uint32_t *code)
{
	uint8_t *md;
	size_t dlen;

#if ENDIAN_ME == ENDIAN_LITTLE
	counter = (((uint64_t)htonl(counter))<<32) + htonl(counter>>32);
#endif

	if (hmac(key,keylen,&counter,sizeof(counter),&md,&dlen))
		return OTP_RETURN_OOM;

	*code = code_trunc(md,dlen,digits);

	free(md);

	return OTP_RETURN_OK;
}




int hotp(const char *secret, const int len, const uint32_t counter, unsigned int digits, uint32_t *num)
{
	int decseclen = (len*5/8)+2;
	uint8_t *decsec;
	
	decsec = malloc(decseclen);
	if (decsec == NULL)
		return OTP_RETURN_OOM;
	
	decseclen = base32_decode(secret, decsec, decseclen);
	
	return otp(decsec, decseclen, digits, counter, num);
}



int totp(const char *secret, const int len, const uint32_t interval, unsigned int digits, uint32_t *num)
{
	time_t now;
	int decseclen = (len*5/8)+2;
	uint8_t *decsec;
	
	decsec = malloc(decseclen);
	if (decsec == NULL)
		return OTP_RETURN_OOM;
	
	now = time(NULL);
	if (interval == 0 || now == (time_t)-1)
		return OTP_RETURN_OTHER;
	
	now /= interval;
	
	decseclen = base32_decode(secret, decsec, decseclen);
	
	return otp(decsec, decseclen, digits, now, num);
}
