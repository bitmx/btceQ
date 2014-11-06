#define KXVER 3

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <curl/curl.h>
#include "k.h"

struct string {
  char *ptr;
  size_t len;
};

void init_string(struct string *s) {
  s->len = 0;
  s->ptr = malloc(s->len+1);
  if (s->ptr == NULL) {
    fprintf(stderr, "malloc() failed\n");
    exit(1);
  }
  s->ptr[0] = '\0';
}

size_t writeFunc(void *ptr, size_t size, size_t nmemb, struct string *s)
{
  size_t new_len = s->len + size*nmemb;
  s->ptr = realloc(s->ptr, new_len+1);
  if (s->ptr == NULL) {
    fprintf(stderr, "realloc() failed\n");
    exit(EXIT_FAILURE);
  }
  memcpy(s->ptr+s->len, ptr, size*nmemb);
  s->ptr[new_len] = '\0';
  s->len = new_len;

  return size*nmemb;
}

K urlReq(K url, K params, K header)
{
  CURL *curl;
  CURLcode res;
  char *hdr;
  K ret;
  int i=0;


  struct string s;
  init_string(&s);

  hdr = strtok(header->s, "|");

  curl = curl_easy_init();

  if(curl) {

    struct curl_slist *chunk = NULL;

    while(hdr!=NULL) {
	chunk = curl_slist_append(chunk, hdr);
        hdr = strtok(NULL, "|");
    }

    /* request with the built-in Accept: */
    curl_easy_setopt(curl, CURLOPT_URL, url->s);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, params->s);

    /* redo request with our own custom Accept: */
    res = curl_easy_setopt(curl, CURLOPT_HTTPHEADER, chunk);
    res = curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeFunc);
    res = curl_easy_setopt(curl, CURLOPT_WRITEDATA, &s);
    res = curl_easy_perform(curl);
    /* Check for errors */
    curl_easy_cleanup(curl);

    /* free the custom headers */
    curl_slist_free_all(chunk);

   ret = ktn(KC,s.len);
   for(i=0;i < s.len ;i++)
        kC(ret)[i]=s.ptr[i];

    return (ret);

  }
  return ret;
}
