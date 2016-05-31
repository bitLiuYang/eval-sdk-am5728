#$L$
# Copyright (C) 2015 Ridgerun (http://www.ridgerun.com). 
##$L$

PKG_URL=http://gstreamer.freedesktop.org/src/gst-plugins-bad/
PKG_TARBALL=gst-plugins-bad-1.6.1.tar.xz
PKG_SHA1SUM=4920e6f9cf269193edc1a3446bbba298d65907ee

include ../../../bsp/classes/rrsdk.class
include $(CLASSES)/gstreamer-plugin.class

GSTREAMER_VERSION = gstreamer-1.0

AUTOTOOLS_PARAMS = --enable-openh264 --enable-opus --enable-dtls \
		--enable-srtp --enable-static --disable-introspection --disable-gsm \
		--disable-examples --disable-festival \
		--disable-bz2 --disable-libde265 \
		--disable-linsys --disable-fbdev --disable-apexsink \
		--disable-curl --disable-dc1394 --disable-directfb \
		--disable-faac --disable-flite --disable-gme \
		--disable-ladspa --disable-lv2 --disable-mimic --disable-modplug \
		--disable-mpeg2enc --disable-mplex --disable-musepack \
		--disable-neon --disable-ofa --disable-openal --disable-opencv \
		--disable-pvr --disable-sdl --disable-sndfile --disable-soundtouch \
		--disable-spandsp --disable-teletextdec --disable-timidity \
		--disable-vdpau --disable-voamrwbenc --disable-wildmidi \
		--disable-xvid --disable-zbar --disable-sdi --disable-hls --disable-qt

# We disable SDL because if you have installed sdl-config on the host, it will mess
LIBRARIES = /usr/lib/{libgstbadbase-1.0.so.0.601.0,libgstbadvideo-1.0.so.0.601.0,libgstadaptivedemux-1.0.so.0.601.0} \
		/usr/lib/{libgstcodecparsers-1.0.so.0.601.0,libgstinsertbin-1.0.so.0.601.0,libgstmpegts-1.0.so.0.601.0} \
		/usr/lib/{libgstphotography-1.0.so.0.601.0,libgsturidownloader-1.0.so.0.601.0} 

LIBRARIES_OPTIONAL = /usr/lib/libgstbasecamerabinsrc-1.0.so.0.601.0

ifeq ($(CONFIG_DUCATI_DEPENDENCIES),y)
	APPS_CPPFLAGS += -I$(FSDEVROOT)/usr/include/libdrm -I$(FSDEVROOT)/usr/include -I$(FSDEVROOT)/usr/include/dce
	AUTOTOOLS_PARAMS += CPPFLAGS="$(APPS_CPPFLAGS)" --enable-shm --enable-kms --enable-libmms --enable-dvb
	LIBRARIES += /usr/lib/{libgstdrm-1.0.so.0.601.0,libgstdrm-1.0.so,libgstdrm-1.0.so.0} \
			/usr/lib/gstreamer-1.0/libgstkmssink.so
else
	AUTOTOOLS_PARAMS += --disable-shm --disable-kms --disable-libmms --disable-dvb
endif
