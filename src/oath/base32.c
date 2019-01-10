#include "base32.h"

int base32_decode(const char *enc, uint8_t *res, int len){
	int i;
	int buffer = 0;
	int count = 0;
	int rem = 0;
	char c;

	for(i=0;enc[i];i++){
		c = enc[i];
		if ((c>='A' && c<='Z') || (c>='a' && c<='z'))
			c = (c&0x1F)-1;
		else if (c>='2' && c<='7')
			c -= '2'-26;
		else
			continue;

		buffer = (buffer<<5)|c;
		rem += 5;
		if (rem >= 8) {
			rem -= 8;
			res[count++] = buffer>>rem;
		}
	}

	if (count < len)
		res[count] = 0;

	return count;
}
