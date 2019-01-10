#include "hmac.h"

#include <openssl/hmac.h>

int hmac(const void *key, size_t keylen, const void *msg, size_t msglen, uint8_t **out, size_t *outlen){
	unsigned int olen;

	*out = malloc(EVP_MAX_MD_SIZE);
	HMAC(EVP_sha1(), key, keylen, msg, msglen, *out, &olen);
	*outlen = olen;

	return 0;
}
