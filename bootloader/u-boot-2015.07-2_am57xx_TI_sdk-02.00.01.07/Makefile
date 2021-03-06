#$L$
# Copyright (C) 2010-2014 Ridgerun (http://www.ridgerun.com). 
#$L$

.PHONY: build clean scripts relflags real_build buildenv

include ../../bsp/classes/rrsdk.class
include $(CLASSES)/fetcher.defs
include $(CLASSES)/flags.defs

# For targets only required when installing an SD image
SD_INSTALLATION=
ifeq ($(CONFIG_INSTALLER_MODE_SD_CARD),y)
SD_INSTALLATION=y
else ifeq ($(CONFIG_INSTALLER_MODE_SD_CARD_INSTALLER),y)
SD_INSTALLATION=y
endif

include arch/Makefile.rules
include mach/Makefile.rules

MKIMAGE = ./src/tools/mkimage -A arm -O linux 
IMAGES = $(DEVDIR)/images/

PKG_NAME=$(BOOTLOADER)
BOOTLOADER_TARBALL?=$(BOOTLOADER).tar.bz2
PKG_TARBALL=$(BOOTLOADER_TARBALL)
FETCHER_EXTRACT_DIRECTORY_NAME=src
PKG_URL=$(BOOTLOADER_URL)
PKG_TYPE=$(BOOTLOADER_TYPE)
PKG_REVISION=$(BOOTLOADER_REVISION)


ifeq ($(CONFIG_BSP_ARCH_KERNEL_COMPRESS),y)
KERNEL_LOAD_ADDRESS=$(CONFIG_BSP_ARCH_SDRAM_BASE)
else
KERNEL_LOAD_ADDRESS=$(CONFIG_BSP_ARCH_KERNEL_LOAD_ADDRESS)
endif

ifeq ($(CONFIG_UBOOT_NAND_FLASH_MEMORY),y)
CPPFLAGS+= -DCONFIG_SYS_USE_NAND
endif

ifeq ($(CONFIG_UBOOT_NOR_FLASH_MEMORY),y)
CPPFLAGS+= -DCONFIG_SYS_USE_NOR -DCONFIG_SYS_FLASH_SECT_SZ=$(CONFIG_UBOOT_FLASH_BLK_SIZE) -DPHYS_FLASH_SIZE=$(CONFIG_UBOOT_FLASH_SIZE)
endif

EMMC_INSTALLATION=
ifeq ($(CONFIG_INSTALLER_MODE_EMMC),y)
EMMC_INSTALLATION=y
endif

build: $(BOOTLOADER) $(PATCHED_FLAG) arch_build mach_build relflags $(BUILT_FLAG) copy_images arch_post_build mach_post_build scripts buildenv

buildenv:
ifeq ($(CONFIG_UBOOT_FW_PRINTENV),y)
	$(V) $(MAKE) -C src HOSTCC=$(TOOLCHAIN_PREFIX)-gcc env $(QOUT) $(ERRQOUT)
	$(V) cp src/tools/env/fw_printenv $(FSROOT)/usr/bin
	$(V) ( cd $(FSROOT)/usr/bin ; rm -f fw_setenv ; ln -s fw_printenv fw_setenv )
	$(V) if [ -e mach/fw_env.config ] ; then \
	     cp mach/fw_env.config $(FSROOT)/etc; \
	fi
endif

relflags:
	$(V) echo $(CPPFLAGS) > relflags.tmp
	$(V) if [ -f relflags ] && ! diff relflags relflags.tmp >/dev/null ; then \
	    $(ECHO) "Rebuilding $(BOOTLOADER) since compile flags changed..." ; \
	    $(MAKE) real_build ; \
	else \
	    mv relflags.tmp relflags ; \
	fi

$(CONFIGURED_FLAG):
	$(V) $(MAKE) -C src $(UBOOT_BOARD_CONFIG) CROSS_COMPILE="$(CCACHE) $(TOOLCHAIN_PATH)/bin/$(TOOLCHAIN_PREFIX)"- RELFLAGS="$(CFLAGS)"
	$(V) touch $@

#Some platforms like the DM8148 needs an extra parameter with the uboot name when uboot will be built,
#in this cases, the variable TI_NAME must be set properly in mach/Makefile.rules
real_build:
ifeq ($(CONFIG_UBOOT_DEBUG),y)
ifeq ($(CONFIG_UBOOT_DEBUG_GDB),y)
	$(V) $(MAKE) OPTFLAGS='-Os -fno-schedule-insns -fno-schedule-insns2' DBGFLAGS='-ggdb' -C src -j $(BSP_NCPU) CROSS_COMPILE="$(CCACHE) $(TOOLCHAIN_PATH)/bin/$(TOOLCHAIN_PREFIX)"- \
		CONFIG_SYS_TEXT_BASE=$(CONFIG_UBOOT_RAM_ADDRS) EXTRA_CPPFLAGS="$(CPPFLAGS)" $(QOUT) $(ERRQOUT)
else
	$(V) $(MAKE) OPTFLAGS='-Os -fno-schedule-insns -fno-schedule-insns2' DBGFLAGS='-g' -C src -j $(BSP_NCPU) CROSS_COMPILE="$(CCACHE) $(TOOLCHAIN_PATH)/bin/$(TOOLCHAIN_PREFIX)"- \
		CONFIG_SYS_TEXT_BASE=$(CONFIG_UBOOT_RAM_ADDRS) EXTRA_CPPFLAGS="$(CPPFLAGS)" $(QOUT) $(ERRQOUT)
endif
else
	$(V) $(MAKE) -C src -j $(BSP_NCPU) CROSS_COMPILE="$(CCACHE) $(TOOLCHAIN_PATH)/bin/$(TOOLCHAIN_PREFIX)"- \
		CONFIG_SYS_TEXT_BASE=$(CONFIG_UBOOT_RAM_ADDRS) CONFIG_EMMC_INSTALL=$(EMMC_INSTALLATION) EXTRA_CPPFLAGS="$(CPPFLAGS)" $(QOUT) $(ERRQOUT)
endif

copy_images::
	$(V) if [ -e src/u-boot.img ] ; then \
	     cp src/u-boot.img $(BOOTLOADERIMAGE) ; \
	     cp src/u-boot*img $(IMAGES) ; \
	     cp src/MLO $(IMAGES) ; \
	else \
	     cp src/u-boot.bin $(BOOTLOADERIMAGE) ; \
	     cp src/MLO $(IMAGES) ; \
	fi
	$(V) cp src/u-boot*bin* $(IMAGES)
ifneq ($(CONFIG_BSP_ARCH_INSTALLER_IPL_GENERATION_TARGET),)
	$(V) make $(CONFIG_BSP_ARCH_INSTALLER_IPL_GENERATION_TARGET)
endif
ifneq ($(CONFIG_BSP_ARCH_INSTALLER_UBOOT_FLASH_GENERATION_TARGET),)
	$(V) make $(CONFIG_BSP_ARCH_INSTALLER_UBOOT_FLASH_GENERATION_TARGET)
endif

$(BUILT_FLAG): $(CONFIGURED_FLAG)
	$(V) $(ECHO) "Building $(BOOTLOADER)..."
	$(V) $(MAKE) real_build
	$(V) touch $@

ifneq ($(BOOTLOADER_TARBALL),)
BOOTLOADER_URL?=https://$(DOWNLOAD_SERVER)/packages/
endif

ifneq ($(BOOTLOADER_URL),)
$(BOOTLOADER): $(FETCHED_FLAG)
else
$(BOOTLOADER):
	$(V)$(ECHO) "\n$${ERROR_COLOR}Error:$${NORMAL_COLOR} no BOOTLOADER_URL or BOOTLOADER_TARBALL defined, and bootloader code not found... aborting\n";
	$(V) exit -1;
endif

src: $(BOOTLOADER)

preconfig: ConfigExtra

ConfigExtra: Config.template
	$(V) cp $< $@
	$(V) echo "source bootloader/$(BOOTLOADER)/arch/Config" >> $@
	$(V) echo "source bootloader/$(BOOTLOADER)/mach/Config" >> $@

buildfs:

clean: arch_clean mach_clean unpatch
	$(V) if ! [ -f src/.svn ] ; then \
	    rm -Rf src $(FETCHED_FLAG) ; \
	else \
	    if [ -d src ] ; then \
		$(MAKE) -C src CROSS_COMPILE="$(CCACHE) $(TOOLCHAIN_PATH)/bin/$(TOOLCHAIN_PREFIX)"- distclean ; \
	    fi ; \
	fi
	$(V) find . -name .depend | xargs rm -f {}
	$(V) rm -f *.o *.d $(CONFIGURED_FLAG) \
	$(BUILT_FLAG) relflags relflags.tmp .fsloadhex


#################################################################
#			Scripts Section				#
#################################################################

scripts:
ifeq ($(CONFIG_BSP_ARCH_KERNEL_COMPRESS),y)
	@$(ECHO) Building bootloader compressed uImage
	@# Build the kernel image
	$(V)$(MKIMAGE) -T kernel -C none -a $(CONFIG_BSP_ARCH_KERNEL_ZTEXTADDR) \
	-e $(CONFIG_BSP_ARCH_KERNEL_ZTEXTADDR) \
	-n "\"RR Compressed Linux Kernel\"" -d $(KERNELIMAGE) $(KERNELIMAGE).uImage > /dev/null
else
	@$(ECHO) Building bootloader uncompressed uImage
	@# Build the kernel image
	$(V)$(MKIMAGE) -T kernel -C none -a $(CONFIG_BSP_ARCH_KERNEL_LOAD_ADDRESS) \
	-e $(CONFIG_BSP_ARCH_KERNEL_ENTRY_ADDRESS) \
	-n "\"RR Linux Kernel\"" -d $(KERNELIMAGE) $(KERNELIMAGE).uImage > /dev/null
endif
	@# Load the file system image after the kernel image (dirty calcs)
	$(V)declare -i KEND=0x`tail -1 $(DEVDIR)/kernel/$(KERNEL)/System.map | cut -f1 -d\ ` ; \
	KEND=$$KEND/4096 ; \
	KEND=$$KEND+4 ; \
	KEND=$$KEND*4096 ; \
	declare -i FSLOAD=$$KEND-1073741824 ; # convert from 0xC.. to 0x8... \
	FSLOADHEX=`echo $$FSLOAD 16o p | dc` ; \
	echo $$FSLOADHEX >.fsloadhex 
ifeq ($(CONFIG_FS_TARGET_INITRD),y)
	$(V)$(MKIMAGE) -T ramdisk -C none -a `cat .fsloadhex` \
	-n "\"RR File System Image\"" -d $(IMAGES)fsimage $(FSIMAGE).uImage $(QOUT) ;
else
ifneq ($(CONFIG_FS_TARGET_NFSROOT),y)
	@# Other file systems that are not NFS or initrd live directly on flash
	@# so we don't build a uImage for them, only load the raw file
ifneq ($(CONFIG_FS_TARGET_SD),y)
	$(V)if [ -e $(IMAGES)fsimage ] ; then \
	    cp $(IMAGES)fsimage $(FSIMAGE).uImage $(QOUT) ; \
	fi

else
	@# Empty fs image file for SD FS
	$(V)rm -f $(FSIMAGE).uImage $(QOUT)
	$(V)touch $(FSIMAGE).uImage $(QOUT)
endif
else
	@# Empty fs image file for NFS
	$(V)rm -f $(FSIMAGE).uImage $(QOUT)
	$(V)touch $(FSIMAGE).uImage $(QOUT)
endif
endif
