#!/bin/bash

SDK_DIR=$1

echo "patching $SDK_DIR/sources/yocto/meta-realtek/tools/firmware.sh"
sed -i 's/ -s xip//g' $SDK_DIR/sources/yocto/meta-realtek/tools/firmware.sh

