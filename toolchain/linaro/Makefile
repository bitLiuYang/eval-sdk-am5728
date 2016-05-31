#$L$
# Copyright (C) 2013 Ridgerun (http://www.ridgerun.com). 
#
#  This source code has a dual license.  If this file is linked with other
#  source code that has a GPL license, then this file is licensed with a GPL
#  license as described below.  Otherwise the source code contained in this
#  file is property of Ridgerun. This source code is protected under
#  copyright law.
#
#  This program is free software; you can redistribute  it and/or modify it
#  under  the terms of  the GNU General  Public License as published by the
#  Free Software Foundation;  either version 2 of the  License, or (at your
#  option) any later version.
#
#  THIS  SOFTWARE  IS  PROVIDED  ``AS  IS''  AND   ANY  EXPRESS  OR IMPLIED
#  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
#  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT,  INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
#  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
#  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
#  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
#  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#  You should have received a copy of the  GNU General Public License along
#  with this program; if not, write  to the Free Software Foundation, Inc.,
#  675 Mass Ave, Cambridge, MA 02139, USA.
#$L$


.PHONY: build chkconfig preconfig buildfs clean

ifeq ($(DEVDIR),)
$(error ====== DEVDIR variable is empty, invoke this Makefile from the BSP root, or provide the path to it =====)
endif
include $(DEVDIR)/bsp/mach/Make.conf

ifeq ($(CONFIG_TOOLCHAIN_HARDFP),y)
    export HARDFP=1
    LINARO_VERSION := 2.21
    LIBSTDC++_VERSION := 21
    COPYRIGHTS := hardfp
    LIB_PATH := $(TOOLCHAIN_LIB)
else
    export HARDFP=0 
    LINARO_VERSION := 2.13
    LIBSTDC++_VERSION := 16
    COPYRIGHTS := softfp
    LIB_PATH := $(TOOLCHAIN_LIB)/../../../lib
endif   

# Build the base file system, install the toolchain libraries
build: copyrights.xml
	chmod +x download_toolchain.sh	
	./download_toolchain.sh $(DOWNLOAD_SERVER)
	# We install all the applications during the normal build process, but only
	# if the FSROOT directory already exists, otherwise we may break the detection
	# for running the buildfs target if required, because we will create the FSROOT ahead of time
	if [ -d $(FSROOT) ] ; then \
	    $(MAKE) buildfs ; \
	fi

copyrights.xml:
	ln -sf $@.$(COPYRIGHTS) $@

buildfs:
	$(V) mkdir -p $(FSROOT)/{lib,usr/bin}
	# Installing the dynamic loader
	$(V) install -D --mode=755 $(TOOLCHAIN_LIB)/ld-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	# Installing shared libc
	$(V) install -D --mode=755 $(TOOLCHAIN_LIB)/libc-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	# Installing shared libdl
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libdl-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	# Installing shared libgcc
	$(V)install -D --mode=755 $(LIB_PATH)/libgcc_s.so.1 \
	    $(FSROOT)/lib/
	# Installing shared libm
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libm-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	# Installing shared libnsl
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libnsl-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	# Installing shared libnss (minimals, compat,files,dns)
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libnss_compat-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libnss_dns-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libnss_files-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	# Installing shared libpthread
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libpthread-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	# Installing shared libresolv
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libresolv-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	# Installing shared libutil
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libutil-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	# Installing shared libcrypt
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libcrypt-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	# Installing shared librt
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/librt-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	# Installing others
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libBrokenLocale-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libanl-$(LINARO_VERSION).so \
	    $(FSROOT)/lib/
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libthread_db-1.0.so \
	    $(FSROOT)/lib/libthread_db-1.0.so

ifeq ($(CONFIG_TOOLCHAIN_INSTALL_CPP_SUPPORT),y)
	# Installing shared libstdc++ and friends
	$(V) install -D --mode=755 $(LIB_PATH)/libstdc++.so.6.0.$(LIBSTDC++_VERSION) \
	    $(FSROOT)/lib/libstdc++.so.6.0.$(LIBSTDC++_VERSION)
endif

ifeq ($(CONFIG_TOOLCHAIN_INSTALL_GCONV_MODULES),y)
	# Installing GCONV conversion tables required to use iconv utility
	$(V) mkdir -p $(FSROOT)/usr/lib/gconv
	$(V) install -D --mode=755 $(TOOLCHAIN_LIB)/../usr/lib/gconv/* $(FSROOT)/usr/lib/gconv/
endif

ifeq ($(CONFIG_TOOLCHAIN_INSTALL_GDBSERVER),y)
	# Installing gdbserver
	$(V)install -D --mode=755 $(TOOLCHAIN_BIN)/../$(TOOLCHAIN_PREFIX)/debug-root/usr/bin/gdbserver $(FSROOT)/usr/bin/gdbserver
	$(V)install -D --mode=755 $(TOOLCHAIN_LIB)/libthread_db-1.0.so \
	    $(FSROOT)/lib/libthread_db-1.0.so
endif
ifeq ($(CONFIG_TOOLCHAIN_INSTALL_LDD),y)
	# Installing ldd
	$(V)install -D --mode=755 $(TOOLCHAIN_BIN)/ldd $(FSROOT)/usr/bin/ldd
endif

preconfig:
	$(V) mkdir -p $(LOCALDIR)
	$(V) ln -sf $(TOOLCHAIN_BIN)/$(TOOLCHAIN_PREFIX)-gcc $(LOCALDIR)/bin/$(TOOLCHAIN_PREFIX)-gcc
	$(V) ln -sf $(TOOLCHAIN_BIN)/$(TOOLCHAIN_PREFIX)-g++ $(LOCALDIR)/bin/$(TOOLCHAIN_PREFIX)-g++
	$(V) ln -sf $(TOOLCHAIN_BIN)/$(TOOLCHAIN_PREFIX)-cpp $(LOCALDIR)/bin/$(TOOLCHAIN_PREFIX)-cpp

cmdline:

patch:

unpatch:

clean: 
	$(V) if [ -f "copyrights.xml" ]; then \
		rm copyrights.xml; \
	fi;
