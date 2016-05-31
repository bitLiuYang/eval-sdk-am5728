#$L$
# Copyright (C) 2015 Ridgerun (http://www.ridgerun.com)
##$L$

PKG_URL=http://gstreamer.freedesktop.org/src/gst-plugins-ugly/
PKG_TARBALL=gst-plugins-ugly-1.6.1.tar.xz
PKG_SHA1SUM=b55c791fe1e44f79c8ca9de21a90b1c6b54518f2

GSTREAMER_VERSION=gstreamer-1.0

AUTOTOOLS_PARAMS = --disable-examples --disable-iec958 --disable-mpegstream --disable-cdio --disable-sidplay --disable-twolame

#AUTOTOOLS_PARAMS = --disable-rpath --disable-valgrind --disable-nls \
#--disable-examples  --disable-gtk-doc --disable-a52dec --disable-amrnb --disable-dvdread \
#--disable-lame --disable-mpeg2dec --disable-sidplay


include ../../../bsp/classes/rrsdk.class
include $(CLASSES)/gstreamer-plugin.class

