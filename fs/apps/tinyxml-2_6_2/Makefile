#$L$
# Copyright (C) 2015 Ridgerun (http://www.ridgerun.com). 
##$L$

PKG_URL=http://downloads.sourceforge.net/project/tinyxml/tinyxml/2.6.2
PKG_TARBALL=tinyxml_2_6_2.tar.gz
PKG_SHA1SUM=cba3f50dd657cb1434674a03b21394df9913d764

AUTOTOOLS_AUTOGEN_GENERATION_RULE=$(AUTOTOOLS_SRC_DIR)/autogen.sh

#AUTOTOOLS_PARAMS=

BINARIES= /usr/bin/{gif2raw,gif2rgb,gifbuild,gifecho,giffix,gifinter,gifinto,giftext,giftool,gifclrmp}
LIBRARIES= /usr/lib/libtinyxml-0.0.0.so.0.0.0
LINKS= /usr/lib/{libtinyxml-0.0.0.so.0,libtinyxml.so}

include ../../../bsp/classes/rrsdk.class
include $(CLASSES)/autotools.class

$(AUTOTOOLS_SRC_DIR)/autogen.sh:
	$(V)echo "#!/bin/sh" > $@
	$(V)echo "" >> $@
	$(V)echo "autoreconf --verbose --force --install --make || {" >> $@
	$(V)echo "	echo 'autogen.sh failed';" >> $@
	$(V)echo "	exit 1;" >> $@
	$(V)echo "}" >> $@
	$(V)echo "" >> $@
	$(V)chmod a+x $@

