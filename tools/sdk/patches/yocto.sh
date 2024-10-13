#!/bin/bash

SDK_DIR=$1

echo "remove $SDK_DIR/sources/yocto/meta-realtek/tools/sdk"
rm -rf $SDK_DIR/sources/yocto/meta-realtek/tools/sdk
