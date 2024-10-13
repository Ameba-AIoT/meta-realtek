#!/bin/bash

SDK_DIR=$1

echo "remove $SDK_DIR/sources/prebuilts/speech"
rm -rf $SDK_DIR/sources/prebuilts/speech

echo "remove $SDK_DIR/sources/prebuilts/build-tools"
rm -rf $SDK_DIR/sources/prebuilts/build-tools
