#!/bin/bash

SDK_DIR=$1

echo "remove $SDK_DIR/sources/development/bluetooth/rtlbtmp/src"
rm -rf $SDK_DIR/sources/development/bluetooth/rtlbtmp/src

echo "remove $SDK_DIR/sources/development/apps/ota"
rm -rf $SDK_DIR/sources/development/apps/ota

echo "remove $SDK_DIR/sources/development/apps/samples"
rm -rf $SDK_DIR/sources/development/apps/samples

echo "remove $SDK_DIR/sources/development/apps/speech"
rm -rf $SDK_DIR/sources/development/apps/speech

echo "remove $SDK_DIR/sources/development/apps/pangu_app/src"
rm -rf $SDK_DIR/sources/development/apps/pangu_app/src
