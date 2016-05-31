
build: libmemcpy_neon.so

memcpy_neon.o: memcpy_neon.S
	arm-none-linux-gnueabi-gcc -I. -DFNAME=memcpy_neon -O2 -mcpu=cortex-a8 -mfpu=neon -mfloat-abi=softfp -c -fPIC memcpy_neon.S

libmemcpy_neon.so: memcpy_neon.o
	arm-none-linux-gnueabi-gcc -shared -Wl,-soname,libmemcpy_neon.so -o libmemcpy_neon.so memcpy_neon.o

install: libmemcpy_neon.so
	install libmemcpy_neon.so ../../../../fs/fs/usr/lib/
	install libmemcpy_neon.so ../../../../fs/fsdev/usr/lib/

clean:
	rm -f libmemcpy_neon.so memcpy_neon.o ../../../../fs/fs/usr/lib/libmemcpy_neon.so ../../../../fs/fsdev/usr/lib/libmemcpy_neon.so *~
