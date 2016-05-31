#$L$
# Copyright (C) 2011-2014 Ridgerun (http://www.ridgerun.com). 
#$L$

export DEVDIR=$(shell pwd -L)
COMPONENTS_BUILD = toolchain kernel fs  bootloader installer

# clean in reversed order, e.g. Sigma's mrua relies on that
COMPONENTS_CLEAN = installer bootloader fs kernel toolchain

ifdef RRCONFIG
	# Check the defined RRCONFIG points to this DEVDIR if not use the default value
	ifeq (,$(findstring $(DEVDIR),$(RRCONFIG)))
	RRCONFIG=$(DEVDIR)/bsp/mach/bspconfig
	endif
else
	RRCONFIG=$(DEVDIR)/bsp/mach/bspconfig
endif

export RRCONFIG

include bsp/mach/Make.conf
include bsp/classes/flags.defs

# Used to the graphical output indexation
TABINDEX ?= \040

.PHONY: build config bspconfig bspconfig_batch preconfig buildfs \
clean prebuild header kernel bootloader fs update coreconfig \
help help_targets help_parameters help_examples install

build:: .oscheck header prebuild $(foreach COMP, $(COMPONENTS_BUILD), $(COMP)_build) copyrights

force_build_execute:
	$(V)$(MAKE) build

# Toolchain variable environment is required by bsp/oscheck/pkg
export TOOLCHAIN

# Goals that we need to know about
build-goals-list  := build fs kernel cmdline bootloader
config-goals-list := config bspconfig coreconfig

config-goals := $(filter $(config-goals-list), $(MAKECMDGOALS))
build-goals  := $(filter $(build-goals-list),  $(MAKECMDGOALS))

.oscheck:
#	$(V)cd bsp/oscheck && ./shellcheck && ./oscheck $(SCRIPT_DEBUG) && ./pkg -r $(SCRIPT_DEBUG) && ./osfix
	$(V)cd bsp/oscheck && ./shellcheck && ./oscheck $(SCRIPT_DEBUG) && ./pkg -r $(SCRIPT_DEBUG)
	$(V)touch .oscheck
ifndef config-goals
  ifndef build-goals
	$(V)echo -e "\nRunning initial configuration to load default values...\n"
	$(V)$(MAKE) bspconfig
  endif
endif

header::
	@$(ECHO) "\033[34mRidgerun Linux SDK\033[0m"
	@$(ECHO) "Board configuration: \033[32m$(MACH_DESCRIPTION)\033[0m"
ifneq ($(BSP_NCPU_TOTAL),1)
	@$(ECHO) "Multi-core machine, using \033[34m$(BSP_NCPU)\033[0m out of $(BSP_NCPU_TOTAL) cores for building"
endif
	@$(ECHO)
	@mkdir -p images

prebuild::


#Special seek for ti-flash-utils and patch remove
TI_FLASH_UTILS=$(DEVDIR)/bootloader/$(BOOTLOADER)/ti-flash-utils

patch:: .oscheck header $(foreach COMP, $(COMPONENTS_BUILD), $(COMP)_patch)
	if [ -d $(TI_FLASH_UTILS)/ ] ; then \
                cd $(TI_FLASH_UTILS) ; \
		echo "   Patching ti-flash-utils..."; \
                make patch ; \
        fi;

buildfs:: .oscheck header $(foreach COMP, $(COMPONENTS_BUILD), $(COMP)_buildfs)

unpatch_noheader: $(foreach COMP, $(COMPONENTS_BUILD), $(COMP)_unpatch)
	if [ -d "$(TI_FLASH_UTILS)" ] ; then \
		cd $(TI_FLASH_UTILS) ; \
		make unpatch ; \
	fi;

unpatch:: .oscheck header unpatch_noheader

confirm_clean:
	$(V) $(ECHO) "$(WARN_COLOR)WARNING:$(NORMAL_COLOR) You are about to clean your DEVDIR."
	$(V) read -p  "  Do you want to continue [Y/n] " user_confirmed ; \
	  if [ -z $$user_confirmed ] || [ $$user_confirmed != "y" -a $$user_confirmed != "Y" ] ; then \
	    $(ECHO) "User did not confirmed." ; \
	    exit 255 ; \
	  fi

clean:: confirm_clean .oscheck header $(foreach COMP, $(COMPONENTS_CLEAN), $(COMP)_clean)
	@$(MAKE) -C bsp clean $(MAKE_CALL_PARAMS)
	$(V)rm -rf images/*
	$(V)rm .oscheck .system.id

preconfig:: .oscheck header $(foreach COMP, $(COMPONENTS_BUILD), $(COMP)_preconfig)

config:: .oscheck header bspconfig

bspconfig:: preconfig
	@$(MAKE) -C bsp menuconfig $(MAKE_CALL_PARAMS)
	@$(MAKE) -C fs defs $(MAKE_CALL_PARAMS)
	@$(MAKE) memorymapgen $(MAKE_CALL_PARAMS)

bspconfig_default:: .oscheck header preconfig
	$(V) \
	echo -e "\nThis will revert all previous configuration to the default vales" ; \
	echo -n "Are you sure (yes/no) " ; \
	read ANS ; \
	if test "$$ANS" = "yes" ; then \
	    rm -Rf bsp/mach/bspconfig ; \
	    $(MAKE) -C bsp menuconfig $(MAKE_CALL_PARAMS) ; \
	fi

bspconfig_batch:: .oscheck header preconfig
	@$(MAKE) -C bsp config $(MAKE_CALL_PARAMS)

cmdline:: .oscheck header
	$(V)$(MAKE) -C fs cmdline $(MAKE_CALL_PARAMS)

update: 
	$(V)$(DEVDIR)/bsp/scripts/update $(if $(VERBOSE:0=),-d)

showdirs=0
revision=0
getupdates=0
show_updates: header
	$(V)bsp/scripts/show_updates.pl --revision=$(revision) --showdirs=$(showdirs) --getUpdates=$(getupdates)

env:
	@echo "export DEVDIR=$(DEVDIR)"
	@echo "export PATH=$(BSP_PATH)"
	@echo "export RRCONFIG=$(RRCONFIG)"

ifndef board
board=""
endif
ifndef toolchain 
toolchain=""
endif
ifndef bootloader
bootloader=""
endif
ifndef kernel
kernel=""
endif
ifndef installer
installer=""
endif

coreconfig: .oscheck header
	$(V)$(MAKE) -C kernel $(KERNEL)
	$(V)bsp/scripts/coreconfig $(board) $(toolchain) $(bootloader) $(kernel) $(installer)

doc: .oscheck header 
	$(V) DOXVER=`doxygen --version` ;\
	DOXMAJOR=`echo $$DOXVER | cut -d. -f1`; \
	DOXMINOR=`echo $$DOXVER | cut -d. -f2`; \
	if ! [ $$DOXMAJOR -gt 1 -o \
	       \( $$DOXMAJOR -eq 1 -a $$DOXMINOR -ge 7 \) \
	     ] ; then \
	     $(ECHO) "$(ERROR_COLOR)ERROR:$(NORMAL_COLOR) You need doxygen 1.7 or up to build the documentation. Either Doxygen isn't installed in this system, or it is outdated.\n" ; \
	     exit 255; \
	fi;
	$(V) echo -n -e "  Generating SDK Documentation..."
	$(V) cd documentation ; doxygen doxygen.conf $(QOUT) $(ERRQOUT)
	$(V) $(ECHO) "done\n\n"

prelink: .oscheck header $(DEVDIR)/bsp/local/sbin/prelink
	$(V) $(ECHO) "\n  Prelinking the root filesystem...\n"
	$(V) $(DEVDIR)/bsp/local/sbin/prelink --root fs/fs -v -all -m $(PRELINK_PARAMS)

$(DEVDIR)/bsp/local/sbin/prelink:
	$(V) if [ ! -d fs/host-apps/prelink-cross ] ; then \
	  $(ECHO) "$(ERROR_COLOR)ERROR:$(NORMAL_COLOR) You don't have prelink-cross in your SDK." ; \
	  $(ECHO) " prelink-cross is only available with RidgeRun SDK Professional Version. Please contact RidgeRun for support\n" ; \
	  exit -1 ; \
	else \
	  $(ECHO) "Building prelink-cross..." ; \
	  $(MAKE) -C fs/host-apps/prelink-cross build install ; \
	fi

help:: help_targets help_parameters help_examples

help_targets::
	@echo ""
	@echo "RidgeRun Integrated Linux Software Developer's Kit"
	@echo ""
	@echo "Make targets:"
	@echo ""
	@echo "   build           - build kernel, target filesystem, bootloader"
	@echo "   force_build     - same as build, but forces the recompilation of the target filesystem"
	@echo "   kernel          - build kernel"
	@echo "   fs              - build target filesystem"
	@echo "   cmdline         - build cmdline for target kernel (fs target does the same as well)"
	@echo "   bootloader      - build bootloader"
	@echo "   patch           - fetch the source and apply any patches"
	@echo "   unpatch         - remove all applied patches"
	@echo "   config          - allow SDK to be configured"
	@echo "   config_batch    - attempt to configure without user interaction"
	@echo "   clean           - delete all derived files"
	@echo "   remove_fs       - delete the filesystem"
	@echo "   remove_fsdev    - delete the filesystem staging directory"
	@echo "   update          - checks for repository updates for the SDK"
	@echo "   show_updates    - checks for available updates for the SDK's release;"
	@echo "                     use revision=<number> to specify a particular revision or"
	@echo "                     range (same syntax as svn log) or showdirs=1 to enable showing"
	@echo "                     change details in the log displayed."
	@echo "   env             - displays commands to run to setup shell environment"
	@echo "   coreconfig      - select toolchain, bootloader, and kernel (updates bsp/mach/Make.conf)"
	@echo "   doc             - generate the SDK API documentation into the documentation folder"
	@echo "   prelink         - prelink the root filesystem"
	@echo "   rrsdk_patches_refresh - Update merged series file contains arch, mach, and top level"
	@echo "                     patches.  Only for bootloader, kernel and dvsdk/ezsdk directories."
	@echo "   copyrights      - generate the copyright documentation for every package in the SDK"
	@echo "   copyrights_check - check if the link of each package is valid"
	@echo "   sourcedistro    - generate the source distribution package"

help_parameters::
	@echo ""
	@echo "Make parameters:"
	@echo ""
	@echo "   VERBOSE         - set to 1 to output executing commands"
	@echo "   LOGFILE         - set to built output filename"
	@echo ""
	@echo "Make update parameters:"
	@echo ""
	@echo "   FORCE_UP        - set to force the application/removal of patches"
	@echo ""

help_examples::
	@echo ""
	@echo "Examples:"
	@echo ""
	@echo "   make                   # same as 'make build'"
	@echo "   make VERBOSE=1"

# Alias for old BSP targets like
kernel: kernel_build bootloader_build

bootloader: bootloader_build

fs: fs_build bootloader_build

ifneq ($(strip $(MMAPGEN)),)
include installer/$(MMAPGEN)/Makefile
else
memorymap:
memorymapgen:
endif

ifneq ($(strip $(INSTALLER)),)
include installer/$(INSTALLER)/Makefile
else
installbootloader: install
installkernel: install
installfs: install
install:
	$(V)$(ECHO) "Installer not found. Aborting\n " \
		    "Please verify INSTALLER variable is defined on bsp/mach/Mach.conf."
endif

-include bsp/Makefile.extra

# We are disabling the Makefile.extra temporarely because we want to
# disable all previous installer functionality that is now deprecated
# and the .extra files are used so far only for installer functions.
# We can re-enable on the futue if required
-include bsp/arch/Makefile.extra
-include bsp/mach/Makefile.extra

# Component Function template call
define COMP_template
.PHONY: $(1)$(2)
$(1)$(2):
	$(V)if [ -d $(1) ] ; then \
	  $(ECHO) "Processing $(1)..."; \
	  $(EXECUTE) $(MAKE) -C $(1) $(3) $(MAKE_CALL_PARAMS); \
	fi
endef

# Create a rules for COMPONENTS_BUILD
$(foreach COMP, $(COMPONENTS_BUILD), $(eval $(call COMP_template,$(COMP),_patch,patch)))
$(foreach COMP, $(COMPONENTS_BUILD), $(eval $(call COMP_template,$(COMP),_build)))
$(foreach COMP, $(COMPONENTS_BUILD), $(eval $(call COMP_template,$(COMP),_buildfs,buildfs)))
$(foreach COMP, $(COMPONENTS_BUILD), $(eval $(call COMP_template,$(COMP),_preconfig,preconfig)))
$(foreach COMP, $(COMPONENTS_BUILD), $(eval $(call COMP_template,$(COMP),_unpatch,unpatch)))
$(foreach COMP, $(COMPONENTS_BUILD), $(eval $(call COMP_template,$(COMP),_clean,clean)))

# Rule to remove fs/fs
remove_fs:
	$(V)rm -rf $(DEVDIR)/fs/fs

# Rule to remove fs/fsdev
remove_fsdev: remove_built_flag
	$(V)rm -rf $(DEVDIR)/fs/fsdev

copyrights::
	$(V) $(ECHO) "Generating copyrights..."
	$(V) cd bsp/scripts/copyright && ./copyright_handling.sh $(DEVDIR)/images/components.xml
	$(V) rm $(DEVDIR)/images/components.xml

copyrights_check::
	$(V) $(ECHO) "Generating copyrights..."
	$(V) cd bsp/scripts/copyright && ./copyright_handling.sh $(DEVDIR)/images/components.xml
	$(V) $(ECHO) "Checking copyrights links..."
	$(V) cd bsp/scripts/copyright && ./copyrights_check.sh  $(DEVDIR)/images/components.xml
	$(V) rm $(DEVDIR)/images/components.xml

sourcedistro::
ifneq ($(wildcard images/kernel),)
	$(error ERROR: you can only make a source code distribution tarball from a developement directory that has not been built) 
endif
	$(V) $(ECHO) "Generating patched source code files..."
	$(V) $(MAKE) patch
	$(V) $(ECHO) "Generating Source Distribution Package..."
	$(V) cd bsp/scripts && ./sourcedistro.sh $(QOUT) $(ERRQOUT)

include $(CLASSES)/force_build.defs
