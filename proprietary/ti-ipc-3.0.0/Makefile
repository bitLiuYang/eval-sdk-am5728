#$L$
# Copyright (C) 2016 Ridgerun (http://www.ridgerun.com)
##$L$

PKG_URL=git://git.ti.com/ipc/ipcdev.git
PKG_TYPE=git
PKG_REVISION=dc6c5082f478225b7fbce4216173e6c5b36100b4

include ../../bsp/classes/rrsdk.class
include $(DEVDIR)/bsp/classes/autotools.class

DESTDIR=$(FSDEVROOT)
AUTOTOOLS_PARAMS=--prefix=/usr \
				KERNEL_INSTALL_DIR=$(DEVDIR)/kernel/$(KERNEL) \
				PLATFORM='DRA7XX'

CORRECT_LA=/usr/lib/{libmmrpc.la,libmmrpc.la,libtiipc.la,libtiipc.la,libtitransportrpmsg.la,libtitransportrpmsg.la,libtiipcutils.la,libtiipcutils_lad.la,libtiipcutils.la,libtiipcutils_lad.la}
CORRECT_LA_SED_EXPRESSION=s?libdir='/usr?libdir='$(FSDEVROOT)/usr?g;\
		s?\ /usr/lib?\ $(FSDEVROOT)/usr/lib?g

BINARIES = /usr/bin/lad_dra7xx
LIBRARIES=  /usr/lib/{libtiipcutils.so.1,libtiipcutils_lad.so.1.0.0,libtiipcutils_lad.so.1,libtiipcutils.so} \
	    /usr/lib/{libtiipcutils_lad.la,libtiipcutils_lad.so,libtiipc.so,libtiipc.la} \
	    /usr/lib/{libtiipcutils.la,libtiipc.so.1.0.0,libtiipcutils.so.1.0.0,libtiipc.so.1} \
	    /usr/lib/{libmmrpc.so.1.0.0,libmmrpc.so.1,libmmrpc.so,libmmrpc.la} \
	    /usr/lib/pkgconfig/{libtiipc.pc,libtiipcutils.pc,libmmrpc.pc}
		
		
install::
		$(V) mkdir -p $(FSDEVROOT)/usr/include/ti/ipc/mm
		$(V) cp $(FETCHER_EXTRACT_DIRECTORY_NAME)/packages/ti/ipc/mm/MmRpc.h $(FSDEVROOT)/usr/include/ti/ipc/mm

INIT_SCRIPT=tiipclad.init
INIT_SCRIPT_LEVEL=99
