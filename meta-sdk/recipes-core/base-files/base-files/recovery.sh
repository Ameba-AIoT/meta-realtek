#!/bin/sh

USB_PATH="/mnt/storage/"

MAX_TIMES=10
CNT=0

while [ "$CNT" -lt "$MAX_TIMES" ]; do
    if [ -d "$USB_PATH" ]; then
        SWU_FILES=$(find "$USB_PATH" -name "*.swu")
        if [ ! -z "$SWU_FILES" ]; then
            echo "find $SWU_FILES in usb, update from usb!" > /dev/ttyS0
            /usr/bin/swupdate -i $SWU_FILES -v -k /etc/swupdate-public.pem > /dev/ttyS0
            /usr/bin/fw_setenv entry normal
            #reboot
            exit
        fi
    fi

    CNT=$((CNT + 1))
    sleep 1
done

USERDATA_PATH="/rom/mnt/"
SWU_FILES=$(find "$USERDATA_PATH" -name "*.swu")

if [ ! -z "$SWU_FILES" ]; then
    echo "find $SWU_FILES in userdata, update from userdata!" > /dev/ttyS0
    /usr/bin/swupdate -i $SWU_FILES -v -k /etc/swupdate-public.pem > /dev/ttyS0
    rm -fr $SWU_FILES
    /usr/bin/fw_setenv entry normal
    #reboot
    exit
fi

echo "no *.swu file found in usb or userdata, reset to normal system!" > /dev/ttyS0
/usr/bin/fw_setenv entry normal
#reboot

exit

