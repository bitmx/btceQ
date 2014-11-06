#define KXVER 3
#include <stdio.h>
#include <string.h>
#include <openssl/hmac.h>
#include <iostream>
#include "k.h"

extern "C" K qHMAC512(K data, K key)
 {
    unsigned int SHA512_DIGEST_LENGTH=64;
    unsigned char md[SHA512_DIGEST_LENGTH]; 
    unsigned char result[SHA512_DIGEST_LENGTH];
    unsigned int len=0;


    K ret = ktn(KG,SHA512_DIGEST_LENGTH);

    HMAC_CTX ctx;
    HMAC_CTX_init(&ctx);
 
    HMAC_Init_ex(&ctx, key->s, strlen(key->s), EVP_sha512(), NULL);
    HMAC_Update(&ctx, (unsigned char*)(data->s), strlen(data->s));
    HMAC_Final(&ctx, result, &len);
    HMAC_CTX_cleanup(&ctx);
 

   for(int i=0;i < len ;i++)
	kG(ret)[i]=result[i];	

    return (ret);
}
