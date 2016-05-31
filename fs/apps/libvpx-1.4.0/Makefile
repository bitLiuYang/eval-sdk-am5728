#$L$
# Copyright (C) 2016 Ridgerun (http://www.ridgerun.com). 
##$L$

PKG_URL=https://github.com/webmproject/libvpx.git
PKG_TYPE=git
PKG_REVISION=c74bf6d889992c3cabe017ec353ca85c323107cd
FETCHER_EXTRACT_DIRECTORY_NAME=src

configure_options = --enable-pic --as=yasm --disable-unit-tests --size-limit=16384x16384 --enable-postproc --enable-multi-res-encoding --enable-temporal-denoising --enable-vp9-temporal-denoising --enable-vp9-postproc --enable-shared --enable-realtime-only --enable-onthefly-bitpacking --enable-error-concealment

LIBRARIES=/usr/lib/{libvpx.so,libvpx.so.2,libvpx.so.2.0,libvpx.so.2.0.0}

include ../../../bsp/classes/rrsdk.class
include $(CLASSES)/fetcher.defs

configured: patch
	$(V) cp -R src $(ARCH)
	$(V) cd $(ARCH) ; CROSS=$(TOOLCHAIN_PREFIX)- ./configure $(configure_options) --target=armv7-linux-gcc --prefix=/usr $(QOUT)
	$(V) touch $@

build: rrfetched configured
	$(V) cd $(ARCH) ; $(MAKE) HAVE_GNU_STRIP=no $(QOUT)
	$(V) touch rr$@

installed:
	$(V) cd $(ARCH) ; $(MAKE) install ARCH=$(ARCH) DESTDIR=$(FSDEVROOT) $(QOUT)
	$(V) cd $(ARCH) ; cp libvpx.so* $(DEVDIR)/fs/fs/usr/lib
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

