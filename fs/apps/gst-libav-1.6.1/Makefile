#$L$
# Copyright (C) 2015 Ridgerun (http://www.ridgerun.com)
##$L$

PKG_URL=http://gstreamer.freedesktop.org/data/src/gst-libav
PKG_TARBALL=gst-libav-1.6.1.tar.xz
PKG_SHA1SUM=7fce116ccff9389513eff0074e635b7252d159ec

GSTREAMER_VERSION=gstreamer-1.0

AUTOTOOLS_PARAMS = -with-libav-extra-configure="--extra-cflags= \
		$(subst ",, $(CONFIG_TOOLCHAIN_ARCH_FLAGS)) --target-os=linux --as="

include ../../../bsp/classes/rrsdk.class
include $(CLASSES)/gstreamer-plugin.class

