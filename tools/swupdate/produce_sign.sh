#!/bin/sh

PRODUCT_NAME="linux_yocto"

SCRIPT_PATH=`dirname $0`

#rm priv.pem swupdate-public.pem
#openssl genrsa -out priv.pem
#openssl rsa -in priv.pem -out swupdate-public.pem -outform PEM -pubout

cp $SCRIPT_PATH/pre_install.sh pre_install.sh
cp $SCRIPT_PATH/post_install.sh post_install.sh
cp $SCRIPT_PATH/sw-description-template sw-description

IMAGES="boot.bin app.bin fip.img dtb.img kernel.img rootfs.img pre_install.sh post_install.sh"
MY_FILES="sw-description sw-description.sig $IMAGES"

#cp sw-description-template sw-description
for i in $IMAGES; do
	item_hash=$(sha256sum "$i" | awk '{print $1}')
	sed -i "s/\(.*\)\(sha256 = \"@$i\"\)/\1sha256 = \"$item_hash\"/g" sw-description
done
openssl dgst -sha256 -sign $SCRIPT_PATH/priv.pem -out sw-description.sig sw-description

for i in $MY_FILES;do
    echo $i;done | cpio -ov -H crc >  ${PRODUCT_NAME}.swu

exit
