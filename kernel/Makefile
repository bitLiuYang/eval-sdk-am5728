#$L$
# Copyright (C) 2010 Ridgerun (http://www.ridgerun.com). 
##$L$

export USE_KERNEL_TOOLCHAIN=y

include ../bsp/classes/rrsdk.class
include $(CLASSES)/fetcher.defs
include $(CLASSES)/flags.defs

.PHONY: build real_build preconfig patch buildfs headers_install modules_install soft_clean clean

ifeq ($(TOOLCHAIN),linaro-4.7.1)
export KBUILD_FLAGS = -Wno-unused-but-set-variable -Wno-unused-variable -Wno-maybe-uninitialized -Wno-unused-result -Wno-enum-compare -Wno-deprecated-declarations -Wno-unused-function -Wno-uninitialized -Wno-address
endif

cpu_keys:
	$(V) make -C $(DEVDIR)/proprietary/$(CPU_KEYS) install

cs_tools:
	$(V) make -C $(DEVDIR)/proprietary/$(CS_TOOLS) install

mruafw:
	$(V) make -C $(DEVDIR)/proprietary/$(MRUAFW) install

build: real_build modules_install headers_install
	$(V) $(ECHO) "Build complete"
	$(V)touch $(BUILT_FLAG)

ifeq ($(CONFIG_TANGOX),y)
real_build: $(KERNEL) preconfig patch cpu_keys cs_tools mruafw 
else
real_build: $(KERNEL) preconfig patch
endif
	$(V) ln -sf $(RRCONFIG) $(KERNEL)/.config
	$(V) cat /dev/zero | $(MAKE) -C $(KERNEL) $(KFLAGS) oldconfig $(QOUT) 2>/dev/null
ifeq ($(CONFIG_TANGOX),y)
	$(V) COMPILKIND=$(COMPILKIND) \
	SMP8XXX_OEM_NAME=$(SMP8XXX_OEM_NAME) \
	SMP8XXX_KEY_DOMAIN=$(SMP8XXX_KEY_DOMAIN) \
	SMP8XXX_CHIP_REV=$(SMP8XXX_CHIP_REV) \
	SMP8XXX_STAGE1_CERTID=$(SMP8XXX_STAGE1_CERTID) \
	SMP8XXX_CPU_CERTID=$(SMP8XXX_CPU_CERTID) \
	SMP8XXX_XXENV_CERTID=$(SMP8XXX_XXENV_CERTID) \
	BOOTAUTH_KEY=$(BOOTAUTH_KEY) \
	SMP8XXX_XLOAD_VERSION=$(SMP8XXX_XLOAD_VERSION) \
	XLOAD3_ROOT=$(XLOAD3_ROOT) \
	RMCFLAGS=$(KERNEL_RMCFLAGS) \
	$(MAKE) -j $(BSP_NCPU) -C $(KERNEL) $(KFLAGS) zbimage-linux-xload
	$(MAKE) -j $(BSP_NCPU) -C $(KERNEL) $(KFLAGS) modules
else
	$(V) $(MAKE) -j $(BSP_NCPU) -C $(KERNEL) $(KFLAGS)
endif
	$(ARCH_KERNEL_RULES)
ifeq ($(CONFIG_BSP_ARCH_KERNEL_COMPRESS),y)
ifeq ($(CONFIG_TANGOX),y)
	$(Q)cp $(KERNEL)/arch/$(ARCH)/boot/zbimage-linux-xload $(DEVDIR)/images/zbimage-linux-xload
	$(Q)ln -sf zbimage-linux-xload $(KERNELIMAGE)
else
	$(Q)cp $(KERNEL)/arch/$(ARCH)/boot/zImage $(DEVDIR)/images/vmlinuz
	$(Q)cp $(KERNEL)/arch/$(ARCH)/boot/zImage $(DEVDIR)/images/
	$(Q)ln -sf vmlinuz $(KERNELIMAGE)
endif
else
	$(Q)cp $(KERNEL)/arch/$(ARCH)/boot/Image $(DEVDIR)/images/vmlinux
	$(Q)ln -sf vmlinux $(KERNELIMAGE)
endif
ifeq ($(CONFIG_KERNEL_GENERATE_DEVICE_TREE_BLOB),y)
	$(V) $(MAKE) -C $(KERNEL) ARCH=$(ARCH) $(CONFIG_BSP_MACH_INSTALLER_DTS_FILENAME).dtb 
	$(V) cp $(KERNEL)/arch/$(ARCH)/boot/dts/$(CONFIG_BSP_MACH_INSTALLER_DTS_FILENAME).dtb $(DEVDIR)/images/
	$(V) $(ECHO) "Device tree generated"
endif
	$(V) $(ECHO) "Build complete"

src: $(KERNEL)
	$(V) if [ ! -L src ] ; then \
	    ln -s $(KERNEL) src ; \
	fi

preconfig: rrpreconfig patch

rrpreconfig: $(KERNEL)
	$(V) cd $(KERNEL); \
	if [ ! -L include/asm ] ; then \
	    ln -s asm-$(ARCH) include/asm ; \
	fi ;
	touch $@

patch: $(KERNEL) rrpreconfig
	$(V)$(MAKE) rrpatched

ifneq (x$(KERNEL_TARBALL),x)
  KERNEL_URL=$(DOWNLOAD_SERVER)
endif

ifneq (x$(KERNEL_TYPE),x)
  PKG_TYPE=$(KERNEL_TYPE)
endif

ifneq (x$(KERNEL_REVISION),x)
  PKG_REVISION=$(KERNEL_REVISION)
endif

ifneq (x$(KERNEL_BRANCH),x)
  PKG_BRANCH=$(KERNEL_BRANCH)
endif

FETCHER_EXTRACT_DIRECTORY_NAME=$(KERNEL)
KERNEL_TARBALL?=$(KERNEL).tar.bz2
PKG_TARBALL=$(KERNEL_TARBALL)
PKG_NAME=$(KERNEL)
PKG_URL=$(KERNEL_URL)

ifneq (x$(KERNEL_URL),x)
$(KERNEL): rrfetched
else
$(KERNEL):
	$(V)$(ECHO) "\n$${ERROR_COLOR}Error:$${NORMAL_COLOR} no KERNEL_URL or KERNEL_TARBALL defined, and kernel code not found... aborting\n";
	$(V) exit -1;
endif

buildfs: modules_install

headers_install: $(KERNEL)
	$(V) $(MAKE) -C $(DEVDIR)/fs $(FSDEVROOT) $(QOUT)
	$(V) $(MAKE) -C $(KERNEL) $@ $(KFLAGS) $(QOUT)
	$(V) mkdir -p $(KERNEL_INCLUDE)
	$(V) cp -R $(KERNEL)/usr/include/* $(KERNEL_INCLUDE)

modules_install: $(KERNEL)
	$(V) if [ -d $(FSROOT) ] ; then \
	  $(MAKE) -C $(KERNEL) $(KFLAGS) modules_install INSTALL_MOD_PATH="$(KERNEL)" $(QOUT) ; \
	  if [ ! -d $(FSROOT)/lib/modules ] ; then \
	      mkdir -p $(FSROOT)/lib/modules; \
	  else \
	      find . -name modules.dep* | xargs rm; \
	  fi ; \
	  cp -R $(KERNEL)/$(KERNEL)/lib/modules/* $(FSROOT)/lib/modules ; \
	fi

soft_clean: unpatch
	$(V) if [ -d $(KERNEL) ] ; then \
		$(MAKE) -C $(KERNEL) $(KFLAGS) distclean ; \
	fi;

clean: unpatch
	$(V) if ! [ -d $(KERNEL)/.svn ] ; then \
	    rm -Rf $(KERNEL) rrfetched src rrpreconfig ; \
	else \
	    if [ -d $(KERNEL) ] ; then \
		$(MAKE) -C $(KERNEL) $(KFLAGS) distclean ; \
	    fi ; \
	fi
