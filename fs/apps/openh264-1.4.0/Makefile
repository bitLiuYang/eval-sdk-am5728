#$L$
# Copyright (C) 2016 Ridgerun (http://www.ridgerun.com). 
##$L$

PKG_URL = https://github.com/cisco/openh264/archive
PKG_TARBALL=v1.4.0.tar.gz
PKG_SHA1SUM=709520a591f5236af254a868b56fd4c5503ec929
FETCHER_EXTRACT_DIRECTORY_NAME=src

LIBRARIES=/usr/lib/{libopenh264.so.0,libopenh264.so}

include ../../../bsp/classes/rrsdk.class
include $(CLASSES)/fetcher.defs

configured: patch
	$(V) touch $@

build: rrfetched configured
	$(V) cd $(FETCHER_EXTRACT_DIRECTORY_NAME) ; $(MAKE) ARCH=$(ARCH) CC="$(TOOLCHAIN_PREFIX)-gcc -std=gnu99" CPP"=$(TOOLCHAIN_PREFIX)-gcc -E" CXX="$(TOOLCHAIN_PREFIX)-g++" CXXCPP="$(TOOLCHAIN_PREFIX)-g++ -E" LD="$(TOOLCHAIN_PREFIX)-ld" RANLIB="$(TOOLCHAIN_PREFIX)-ranlib" AR="$(TOOLCHAIN_PREFIX)-ar" AS="$(TOOLCHAIN_PREFIX)-as"
	$(V) touch rr$@

installed:
	$(V) cd $(FETCHER_EXTRACT_DIRECTORY_NAME) ; $(MAKE) install ARCH=$(ARCH) DESTDIR=$(FSDEVROOT)
	$(V) touch $@

install: rrbuild installed rrsdk_install

uninstall:
	$(V)$(MAKE) -C $(ARCH) uninstall $(QOUT)
	$(V) touch $@

clean: unpatch
	$(V) rm -Rf installed built rrbuild configured $(ARCH)

lol:
	echo $(DESTDIR)

distclean: clean rrfetched_clean
