
all: hmac512 http

hmac512: hmac512.cpp
	g++ -shared -fPIC hmac512.cpp -lcrypto -o hmac512.so -m32

http: http.c
	gcc -shared -fPIC http.c -lcurl -o http.so -m32

clean:
	rm -rf *.so
