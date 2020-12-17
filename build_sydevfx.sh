 #!/bin/bash

./compile.sh  BOARD=rockpi-4b BRANCH=legacy RELEASE=buster BUILD_MINIMAL=no BUILD_DESKTOP=yes KERNEL_ONLY=no KERNEL_CONFIGURE=prebuilt COMPRESS_OUTPUTIMAGE=sha,gpg,img LIB_TAG=sydevfx
