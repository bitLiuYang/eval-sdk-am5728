#$L$
# Copyright (C) 2015 Ridgerun (http://www.ridgerun.com). 
##$L$

PKG_URL=http://sourceforge.net/projects/oprofile/files/oprofile/oprofile-0.9.6/
PKG_TARBALL=oprofile-0.9.6.tar.gz
PKG_SHA1SUM=cc62cc58c574e235bc146c8ddc9d9a9af0972fd1
AUTOTOOLS_PARAMS=--with-kernel-support

include ../../../bsp/classes/rrsdk_local.class
include $(CLASSES)/autotools_local.class

install::
	$(V) cp my-import.sh $(DEVDIR)/bsp/local/bin/my-import.sh
	$(V) chmod +x $(DEVDIR)/bsp/local/bin/my-import.sh
