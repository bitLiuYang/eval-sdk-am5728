#$L$
# Copyright (C) 2016 Ridgerun (http://www.ridgerun.com).
##$L$

-include patches/arch/Makefile
-include patches/mach/Makefile
include ../../bsp/classes/rrsdk.class

#Fetcher definition
PKG_TARBALL=$(PSDK_NAME)-trimmed.tar.gz

#====================================================================================================
# AM5728 Platform
#====================================================================================================
ifeq ($(CONFIG_PROPRIETARY_TI_Processor-SDK_AM5728),y)
PSDK_PLATFORM=am5728
PSDK_NAME=ti-processor-sdk-linux-am57xx-evm-02.00.01.07
PSDK_PATHINSDK=$(DEVDIR)/proprietary/processor-sdk-02.00.01.07/
endif

# We are an psdk 5
include $(CLASSES)/psdk5.class
