#$L$
# Copyright (C) 2015 Ridgerun (http://www.ridgerun.com)
##$L$

PKG_URL = http://gstreamer.freedesktop.org/src/gstreamer/
PKG_TARBALL=gstreamer-1.6.1.tar.xz
PKG_SHA1SUM=6ca394c29b00e1c28ec7b0d948ca1d72b37ea66e

DESTDIR=$(FSDEVROOT)
APPS_LDFLAGS+=-Wl,--rpath-link -Wl,$(FSDEVROOT)/usr/lib

AUTOTOOLS_PARAMS=--disable-nls --disable-valgrind --enable-poisoning \
--disable-rpath  --disable-failing-tests \
--disable-examples --disable-tests ac_cv_func_register_printf_function=no \
--prefix=/usr LDFLAGS="$(APPS_LDFLAGS)"

BINARIES= /usr/bin/{gst-inspect-1.0,gst-launch-1.0,gst-typefind-1.0} /usr/libexec/gstreamer-1.0/gst-plugin-scanner
LIBRARIES= /usr/lib/gstreamer-1.0/libgstcoreelements.so \
	/usr/lib/{libgstbase-1.0.so.0.601.0,libgstcheck-1.0.so.0.601.0,libgstcontroller-1.0.so.0.601.0} \
	/usr/lib/{libgstnet-1.0.so.0.601.0,libgstreamer-1.0.so.0.601.0}
# Gstreamer has the peculiarity that setups dependencies on the .la files to himself, and since
# we cross-compile with prefix=/usr/lib, the dependencies end with wrong paths
CORRECT_LA=/usr/lib/{libgstreamer-1.0.la,libgstnet-1.0.la} \
	/usr/lib/{libgstcontroller-1.0.la,libgstcheck-1.0.la,libgstbase-1.0.la} \
	/usr/lib/gstreamer-1.0/libgstcoreelements.la
CORRECT_PKGCONFIG=/usr/lib/pkgconfig/{gstreamer-1.0.pc,gstreamer-base-1.0.pc,gstreamer-check-1.0.pc}\
	/usr/lib/pkgconfig/{gstreamer-controller-1.0.pc,gstreamer-net-1.0.pc}

include ../../../bsp/classes/rrsdk.class
include $(CLASSES)/autotools.class

