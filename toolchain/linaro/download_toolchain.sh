#! /bin/bash

#$L$
# Copyright (C) 2013 Ridgerun (http://www.ridgerun.com). 
##$L$

#Download server URL
readonly DOWNLOAD_SERVER=$1

# Install Directory
readonly INSTALL=/opt/linaro

# Toolchain package name
readonly TOOLCHAIN_DIR=gcc-linaro-5.2-2015.11-2-x86_64_arm-linux-gnueabihf
readonly TOOLCHAIN_PACKAGE=$TOOLCHAIN_DIR.tar.bz2

if [ "$HARDFP" -eq 1 ]
then
	if [ -d "$INSTALL" ]
	then
		if ! [ -d "$INSTALL/$TOOLCHAIN_DIR" ]
		then
			wget $DOWNLOAD_SERVER$TOOLCHAIN_PACKAGE
			sudo tar -xjf $TOOLCHAIN_PACKAGE -C $INSTALL
			rm $TOOLCHAIN_PACKAGE
		fi
	else
		sudo mkdir $INSTALL
		wget $DOWNLOAD_SERVER$TOOLCHAIN_PACKAGE
		sudo tar -xjf $TOOLCHAIN_PACKAGE -C $INSTALL
		rm $TOOLCHAIN_PACKAGE
	fi
fi
exit 0
	
		
