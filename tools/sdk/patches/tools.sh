#!/bin/bash

SDK_DIR=$1

echo "remove $SDK_DIR/tools/ameba/ internal files"
find $SDK_DIR/tools/ameba/ -name *Internal* | xargs rm -rf
