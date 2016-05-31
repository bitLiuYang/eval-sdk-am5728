#$L$
# Copyright (C) 2016 Ridgerun (http://www.ridgerun.com)
##$L$
  
PKG_URL=git://git.omapzoom.org/repo/libdce.git
PKG_TYPE=git
PKG_REVISION=e05d0b506a8f5e9218449d3952ee6c1d327fddb5

include ../../bsp/classes/rrsdk.class
include $(DEVDIR)/bsp/classes/autotools.class

DESTDIR=$(FSDEVROOT)
AUTOTOOLS_PARAMS=--prefix=/usr
AUTOTOOLS_AUTOGEN_PARAMS=--host $(TOOLCHAIN_PREFIX)

CORRECT_LA=/usr/lib/libdce.la
CORRECT_LA_SED_EXPRESSION=s?libdir='/usr?libdir='$(FSDEVROOT)/usr?g;\
		s?\ /usr/lib?\ $(FSDEVROOT)/usr/lib?g

LIBRARIES=  /usr/lib/{libdce.so.1.0.0,libdce.so.1,libdce.so,libdce.la} \
		/usr/lib/pkgconfig/libdce.pc
