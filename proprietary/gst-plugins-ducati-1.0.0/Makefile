#$L$
# Copyright (C) 2016 Ridgerun (http://www.ridgerun.com)
##$L$
  
PKG_URL=git://git.ti.com/glsdk/gst-plugin-ducati.git
PKG_TYPE=git
PKG_REVISION=d201268770ffbb6a13843597d214d585757f1728
PKG_NO_EXCLUDE_DOT_GIT=yes

CPPFLAGS+="-I$(FSDEVROOT)/usr/include/dce -I$(FSDEVROOT)/usr/include/omap -I$(FSDEVROOT)/usr/include"

DESTDIR=$(FSDEVROOT)
AUTOTOOLS_PARAMS=--prefix=/usr CPPFLAGS=$(CPPFLAGS) CFLAGS="$(CFLAGS) -Wno-error"
AUTOTOOLS_AUTOGEN_PARAMS=--host $(TOOLCHAIN_PREFIX) --prefix=/usr 

LIBRARIES=  /usr/lib/gstreamer-1.0/libgstducati.so

include ../../bsp/classes/rrsdk.class
include $(DEVDIR)/bsp/classes/autotools.class
