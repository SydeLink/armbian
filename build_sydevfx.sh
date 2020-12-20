 #!/bin/bash

# Full Build
#./compile.sh  BOARD=rockpi-4b BRANCH=legacy RELEASE=buster BUILD_MINIMAL=no BUILD_DESKTOP=yes KERNEL_ONLY=no KERNEL_CONFIGURE=prebuilt COMPRESS_OUTPUTIMAGE=sha,gpg,img LIB_TAG=sydevfx

# Kernel Only
#./compile.sh  BOARD=rockpi-4b BRANCH=legacy RELEASE=buster BUILD_MINIMAL=no BUILD_DESKTOP=no KERNEL_ONLY=yes KERNEL_CONFIGURE=prebuilt COMPRESS_OUTPUTIMAGE=sha,gpg,img LIB_TAG=sydevfx

# CLEAN Full Build
#./compile.sh  BOARD=rockpi-4b BRANCH=legacy RELEASE=buster BUILD_MINIMAL=no BUILD_DESKTOP=yes KERNEL_ONLY=no KERNEL_CONFIGURE=prebuilt COMPRESS_OUTPUTIMAGE=sha,gpg,img LIB_TAG=sydevfx CLEAN_LEVEL=make,debs,oldcache,alldebs,images,cache,sources

# CLEAN Kernel Only
./compile.sh  BOARD=rockpi-4b BRANCH=legacy RELEASE=buster BUILD_MINIMAL=no BUILD_DESKTOP=no KERNEL_ONLY=yes KERNEL_CONFIGURE=prebuilt COMPRESS_OUTPUTIMAGE=sha,gpg,img LIB_TAG=sydevfx CLEAN_LEVEL=make,debs,oldcache,alldebs,images,cache,sources
