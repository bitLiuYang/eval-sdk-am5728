#$L$
# Copyright (C) 2015 RidgeRun S.A. (http://www.ridgerun.com).
##$L$

FETCHER_NO_DOWNLOAD=yes

AUTOTOOLS_AUTOGEN_GENERATION_RULE=$(AUTOTOOLS_SRC_DIR)/autogen.sh

include ../../../bsp/classes/rrsdk_local.class

include $(CLASSES)/autotools_local.class

$(AUTOTOOLS_SRC_DIR)/autogen.sh:
	$(V)echo "#!/bin/sh" > $@
	$(V)echo "" >> $@
	$(V)echo "autoreconf --verbose --force --install --make || {" >> $@
	$(V)echo "	echo 'autogen.sh failed';" >> $@
	$(V)echo "	exit 1;" >> $@
	$(V)echo "}" >> $@
	$(V)echo "" >> $@
	$(V)chmod a+x $@

