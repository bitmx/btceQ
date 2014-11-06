all: lib

lib: c
	mkdir -p lib; \
	cd c;	\
	make

clean:
	rm -rf lib
