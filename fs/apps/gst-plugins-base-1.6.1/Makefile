#$L$
# Copyright (C) 2015 Ridgerun (http://www.ridgerun.com)
##$L$

include ../../../bsp/classes/rrsdk.class
include $(CLASSES)/gstreamer-plugin.class

PKG_URL=http://gstreamer.freedesktop.org/src/gst-plugins-base/
PKG_TARBALL=gst-plugins-base-1.6.1.tar.xz
PKG_SHA1SUM=c19407b831aa405e51737755d8e47945d93e3a37

GSTREAMER_VERSION=gstreamer-1.0

AUTOTOOLS_PARAMS= --enable-static --program-prefix= --disable-examples

BINARIES= /usr/bin/{gst-discoverer-1.0,gst-play-1.0,gst-device-monitor-1.0}
LIBRARIES= /usr/lib/{libgstallocators-1.0.so.0.601.0,libgstapp-1.0.so.0.601.0,libgstaudio-1.0.so.0.601.0,libgstfft-1.0.so.0.601.0} \
	/usr/lib/{libgstpbutils-1.0.so.0.601.0,libgstriff-1.0.so.0.601.0,libgstrtp-1.0.so.0.601.0} \
	/usr/lib/{libgstsdp-1.0.so.0.601.0,libgsttag-1.0.so.0.601.0,libgstvideo-1.0.so.0.601.0,libgstrtsp-1.0.so.0.601.0}

ifeq ($(CONFIG_DUCATI_DEPENDENCIES),y)
        LIBRARIES += /usr/lib/{libgstdmabuf-1.0.so,libgstdmabuf-1.0.so,libgstdmabuf-1.0.so.0}
endif
