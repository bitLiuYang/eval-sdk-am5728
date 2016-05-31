#$L$
# Copyright (C) 2015 Ridgerun (http://www.ridgerun.com)
##$L$

PKG_URL=http://gstreamer.freedesktop.org/src/gst-plugins-good/
PKG_TARBALL=gst-plugins-good-1.6.1.tar.xz
PKG_SHA1SUM=8e03d083ca5789ff8130bc5b0afff13fea7a2d19

include ../../../bsp/classes/rrsdk.class
include $(CLASSES)/gstreamer-plugin.class

APPS_LDFLAGS += -Wl,--rpath-link -Wl,$(FSDEVROOT)/usr/lib -Wl,--no-undefined
APPS_CFLAGS += -I$(DEVDIR)/kernel/$(KERNEL)/include/

GSTREAMER_VERSION = gstreamer-1.0

AUTOTOOLS_PARAMS = --with-gudev --disable-examples --disable-oss4 --disable-oss --disable-dv1394 --disable-aalib \
		--disable-libcaca --disable-jack --disable-shout2 LDFLAGS="$(APPS_LDFLAGS)" CFLAGS="$(APPS_CFLAGS)"

ifeq ($(CONFIG_FS_APPS_GSTREAMER_PLUGINS_GOOD_V4L2_1_0),y)
    AUTOTOOLS_PARAMS += --enable-experimental --enable-gst_v4l2 
endif
ifeq ($(CONFIG_FS_APPS_GSTREAMER_PLUGINS_GOOD_FLAC_1_0),y)
    AUTOTOOLS_PARAMS += --enable-flac
else
    AUTOTOOLS_PARAMS += --disable-flac
endif
ifeq ($(CONFIG_FS_APPS_GSTREAMER_PLUGINS_GOOD_VPX_1_0),y)
    AUTOTOOLS_PARAMS += --enable-vpx
else
    AUTOTOOLS_PARAMS += --disable-vpx
endif
