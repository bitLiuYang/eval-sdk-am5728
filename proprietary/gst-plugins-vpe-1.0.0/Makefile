#$L$
# Copyright (C) 2016 Ridgerun (http://www.ridgerun.com)
##$L$
  
PKG_URL=git://git.ti.com/glsdk/gst-plugin-vpe.git
PKG_TYPE=git
PKG_REVISION=1a8da5e527275f6bba33663d0d7017d8e1f8f7d9
PKG_NO_EXCLUDE_DOT_GIT=yes

CPPFLAGS+="-I$(FSDEVROOT)/usr/include/dce -I$(FSDEVROOT)/usr/include/omap -I$(FSDEVROOT)/usr/include"

DESTDIR=$(FSDEVROOT)
AUTOTOOLS_PARAMS=--prefix=/usr CPPFLAGS=$(CPPFLAGS) CFLAGS="$(CFLAGS) -Wno-deprecated-declarations -Wno-missing-include-dirs"
AUTOTOOLS_AUTOGEN_PARAMS=--host $(TOOLCHAIN_PREFIX) --prefix=/usr 

LIBRARIES=  /usr/lib/gstreamer-1.0/libgstvpe.so

include ../../bsp/classes/rrsdk.class
include $(DEVDIR)/bsp/classes/autotools.class
