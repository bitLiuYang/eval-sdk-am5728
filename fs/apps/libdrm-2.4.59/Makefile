#$L$
# Copyright (C) 2016 Ridgerun (http://www.ridgerun.com)
##$L$

PKG_URL=https://dri.freedesktop.org/libdrm/
PKG_TARBALL=libdrm-2.4.59.tar.gz
PKG_SHA1SUM=edfaf83c6c5298d6e3a06e09f2dc542a085f9771

include ../../../bsp/classes/rrsdk.class
include $(DEVDIR)/bsp/classes/autotools.class

DESTDIR=$(FSDEVROOT)
AUTOTOOLS_PARAMS=--prefix=/usr --enable-omap-experimental-api --disable-manpages --enable-install-test-programs
AUTOTOOLS_AUTOGEN_PARAMS=--host $(TOOLCHAIN_PREFIX)

CORRECT_LA=/usr/lib/{libdrm.la,libdrm_radeon.la,libdrm_nouveau.la,libdrm_freedreno.la,libdrm_omap.la}
CORRECT_LA_SED_EXPRESSION=s?libdir='/usr?libdir='$(FSDEVROOT)/usr?g;\
		s?\ /usr/lib?\ $(FSDEVROOT)/usr/lib?g

CORRECT_PKGCONFIG=/usr/lib/pkgconfig/libdrm.pc
CORRECT_PKGCONFIG_SED_EXPRESSION=s?prefix=/usr?prefix=$(FSDEVROOT)/usr?g

LIBRARIES=  /usr/lib/{libdrm.so,libdrm.so.2.4.0,libdrm_omap.so,libdrm_omap.so.1.0.0,libdrm_omap.so.1} \
	    /usr/lib/{libdrm_nouveau.so,libdrm_nouveau.so.2,libdrm_nouveau.so.2.0.0} \
	    /usr/lib/{libdrm_radeon.so.1,libdrm_radeon.so,libdrm.so.2,libdrm_radeon.so.1.0.1} \
	    /usr/lib/{libkms.so.1.0.0,libkms.so,libkms.so.1} \
	    /usr/lib/{libdrm.la,libdrm_radeon.la,libdrm_nouveau.la,libdrm_freedreno.la,libdrm_omap.la} \
		/usr/lib/pkgconfig/{libkms.pc,libdrm_nouveau.pc,libdrm.pc,libdrm_omap.pc,libdrm_radeon.pc} \

OTHERS=   /usr/include/libkms/libkms.h \
		/usr/include/libdrm/{drm_fourcc.h,drm.h,drm_mode.h,drm_sarea.h,i915_drm.h,mach64_drm.h,mga_drm.h} \
		/usr/include/libdrm/{nouveau_drm.h,nouveau.h,omap_drmif.h,r128_drm.h,r600_pci_ids.h} \
		/usr/include/libdrm/{radeon_bo_gem.h,radeon_bo.h,radeon_bo_int.h,radeon_cs_gem.h,radeon_cs.h} \
		/usr/include/libdrm/{radeon_cs_int.h,radeon_drm.h,radeon_surface.h,savage_drm.h,sis_drm.h} \
		/usr/include/libdrm/{via_drm.h,vmwgfx_drm.h} \

BINARIES=  /usr/bin/modetest \

install::
		$(V) cp $(FETCHER_EXTRACT_DIRECTORY_NAME)/omap/omap_drm.h $(FSDEVROOT)/usr/include
		$(V) cp $(FETCHER_EXTRACT_DIRECTORY_NAME)/omap/omap_drmif.h $(FSDEVROOT)/usr/include
