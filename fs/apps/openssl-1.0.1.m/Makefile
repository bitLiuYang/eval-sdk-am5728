#$L$
# Copyright (C) 2015 Ridgerun (http://www.ridgerun.com). 
##$L$

# Important Note: 'CROSS_COMPILE' is exported. Hence, passing CC, LD, AR, ...
#                 to the build would result in e.g.:
#                 'arm-linux-gnueabi-arm-linux-gnueabi-gcc'. So don't pass
#                 the toolchain environment here. 

PKG_URL=http://www.openssl.org/source/
PKG_TARBALL=openssl-1.0.1m.tar.gz
PKG_SHA1SUM=4ccaf6e505529652f9fdafa01d1d8300bd9f3179
FETCHER_EXTRACT_DIRECTORY_NAME=src

BINARIES=/usr/bin/openssl
LIBRARIES=/usr/lib/{libcrypto.so.1.0.0,libssl.so.1.0.0} \
          /usr/lib/openssl-1.0.0/engines/{libcswift.so,libatalla.so,libchil.so,libaep.so} \
          /usr/lib/openssl-1.0.0/engines/{libnuron.so,libubsec.so,libsureware.so,libgmp.so} \
          /usr/lib/openssl-1.0.0/engines/{libpadlock.so,libgost.so,libcapi.so,lib4758cca.so}
OTHERS=/usr/ssl/openssl.cnf

include ../../../bsp/classes/rrsdk.class

OPENSSL_CONF_OPT := \
           --prefix=/usr \
           --openssldir=/usr/ssl \
           --install_prefix=$(FSDEVROOT) \
           shared

ifeq ($(ARCH),arm)
OPENSSL_ARCH := debian-armel
else
ifeq ($(ARCH),mips)
OPENSSL_ARCH := debian-mipsel
endif
endif

$(CONFIGURED_FLAG): rrpatched
	$(V) cp -R src $(ARCH)
	$(V) cd $(ARCH) ; ./Configure $(OPENSSL_ARCH) $(OPENSSL_CONF_OPT) $(QOUT)
	$(V) touch $@

$(BUILT_FLAG): $(CONFIGURED_FLAG)
	$(V) touch $(ARCH)/Makefile
	$(V) $(MAKE) -C $(ARCH)
	$(V) touch $@

build: rrfetched $(BUILT_FLAG)

$(INSTALLED_FLAG):
	$(V)$(MAKE) -C $(ARCH) install_sw $(QOUT)
	$(V) touch $@

install: $(INSTALLED_FLAG) rrsdk_install

uninstall:
	$(V)$(MAKE) -C $(ARCH) uninstall $(QOUT)
	$(V) touch $@

clean: unpatch
	$(V) rm -Rf $(INSTALLED_FLAG) $(BUILT_FLAG) $(CONFIGURED_FLAG) $(ARCH)

distclean: clean rrfetched_clean

include $(CLASSES)/fetcher.defs
include $(CLASSES)/flags.defs

