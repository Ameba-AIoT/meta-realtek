#!/bin/sh
#
# Copyright (C) 2024 Realtek
#
export PATH
export status

STATUS_FILE="status.txt"
KERNEL_VERSION=`cat /proc/version | awk '{print $3}'`
built_in="false"
role=""

if [ -e "$STATUS_FILE" ]; then
    status=$(cat "$STATUS_FILE")
else
    status="init"
fi

function insmod_ko()
{
    if [ ! -e "$1" ]; then
        echo "No such file: $1"
        exit 1
    fi
    ko=`basename $1 .ko`
    lsmod | grep ${ko//-/_} > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        insmod $1
    fi
}

function rmmod_ko()
{
    if [ ! -e "$1" ]; then
        echo "No such file: $1"
        exit 1
    fi
    ko=`basename $1 .ko`
    lsmod | grep ${ko//-/_} > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        rmmod $1
    fi
}

function rmmod_class()
{
    if [ "$status" = "usbh_msc_ko" ]; then
        rmmod_usbh_msc_ko
    fi

    if [ "$status" = "usbd_adb_ko" ]; then
        rmmod_usbd_adb_ko
    fi
}

function insmod_otg_ko()
{
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/rtkdrivers/usb_phy/phy-rtk-usb.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/common/usb-common.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/core/usbcore.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/storage/usb-storage.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/udc/udc-core.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/fs/configfs/configfs.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/libcomposite.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/function/usb_f_accessory.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/function/usb_f_hid.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/roles/roles.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/dwc2/dwc2.ko
}

function insmod_usbh_msc_ko()
{
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/rtkdrivers/usb_phy/phy-rtk-usb.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/common/usb-common.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/core/usbcore.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/storage/usb-storage.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/udc/udc-core.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/roles/roles.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/dwc2/dwc2.ko
    status="usbh_msc_ko"
    echo $status > $STATUS_FILE
}

function rmmod_usbh_msc_ko()
{
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/roles/roles.ko
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/dwc2/dwc2.ko
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/udc/udc-core.ko 2>/dev/null
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/storage/usb-storage.ko
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/core/usbcore.ko
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/common/usb-common.ko 2>/dev/null
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/rtkdrivers/usb_phy/phy-rtk-usb.ko
    status="init"
    echo $status > $STATUS_FILE
}

function insmod_usbd_adb_ko()
{
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/rtkdrivers/usb_phy/phy-rtk-usb.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/common/usb-common.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/core/usbcore.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/udc/udc-core.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/fs/configfs/configfs.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/libcomposite.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/function/usb_f_accessory.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/function/usb_f_hid.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/roles/roles.ko
    insmod_ko /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/dwc2/dwc2.ko
    status="usbd_adb_ko"
    echo $status > $STATUS_FILE
}

function rmmod_usbd_adb_ko()
{
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/roles/roles.ko
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/dwc2/dwc2.ko
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/function/usb_f_hid.ko
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/function/usb_f_accessory.ko 2>/dev/null
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/libcomposite.ko 2>/dev/null
    rmmod /lib/modules/$KERNEL_VERSION/kernel/fs/configfs/configfs.ko 2>/dev/null
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/gadget/udc/udc-core.ko 2>/dev/null
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/core/usbcore.ko
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/usb/common/usb-common.ko 2>/dev/null
    rmmod /lib/modules/$KERNEL_VERSION/kernel/drivers/rtkdrivers/usb_phy/phy-rtk-usb.ko
    status="init"
    echo $status > $STATUS_FILE
}

function terminate_acc_release() {
    PID=$(ps | grep /bin/adbd | grep -v grep | awk '{print $1}')
    if [ -n "$PID" ]; then
        kill -9 "$PID" > /dev/null 2>&1
    fi
}

function mount_configfs()
{
    if [ -e "/mnt/config/usb_gadget" ]; then
        umount -f /mnt/config > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "WARNING: Fail to re-mount USB configfs, following operations may result in failure"
            echo "If USB does not work, try:"
        echo "# umount -f /mnt/config"
        echo "# mount none /mnt/config/ -t configfs"
        echo "Or reboot and try again"
            return 0
        fi
    else
        mkdir /mnt/config/ > /dev/null 2>&1
    fi

    mount none /mnt/config/ -t configfs

    if [ ! -e "/mnt/config/usb_gadget" ]; then
        echo "Fail to mount USB configfs"
        return 1
    fi

    return 0
}

function usbh_msc_init()
{
    #Force host mode
    echo 1 > /sys/module/phy_rtk_usb/parameters/usb_force_mode
}

function usbd_acc_init()
{
    local arg=${1:-0}
    echo "ACC init"

    mount_configfs

    cd /mnt/config/usb_gadget
    mkdir acc > /dev/null 2>&1
    cd acc
    echo 0x0200 > bcdUSB

    echo 64 > bMaxPacketSize0

    #adb will filter devices according to bDeviceClass, bDeviceSubClass and bDeviceProtocol
    echo 0xff > bDeviceClass
    echo 0x42 > bDeviceSubClass
    echo 0x01 > bDeviceProtocol

    echo 0x0BDA > idVendor
    echo 0x8730 > idProduct

    mkdir strings/0x409 > /dev/null 2>&1
    echo "Realtek" > strings/0x409/manufacturer
    echo "ADB Interface" > strings/0x409/product
    cat /proc/realtek/uuid > strings/0x409/serialnumber

    mkdir configs/c.1 > /dev/null 2>&1
    echo 120 > configs/c.1/MaxPower
    mkdir configs/c.1/strings/0x409 > /dev/null 2>&1
    echo "accessary" > configs/c.1/strings/0x409/configuration

    mkdir functions/accessory.adb > /dev/null 2>&1
    ln -sf functions/accessory.adb configs/c.1/
    #Force device mode in adb
    if [ "$arg" -eq 2 ]; then
       echo "$arg" > /sys/module/phy_rtk_usb/parameters/usb_force_mode
    fi
}

function active_device()
{
    echo "Activate device"
    # Activate device
    ls /sys/class/udc > UDC
}

function deactive_device()
{
    echo "Deactivate device"
    # Activate device
    echo "" > UDC
}

function usb_usage()
{
    echo "Usage: $0 [-b] [-r <role>]"
    echo
    echo "Description:"
    echo "  -b,                  Optional: Use built-in mode."
    echo "  -r <role>,           Mandatory: Specify the role to execute."
    echo
    echo "Where role:"
    echo "  otg                  OTG mode"
    echo "  usbh_msc             MSC host"
    echo "  usbd_adb             ADB device"
    echo
    echo "Example:"
    echo "  $0 -b -r otg"
    echo "  $0 -r usbd_adb"
    exit 1
}

while getopts 'br:h' OPT; do
    case $OPT in
        b)
            built_in=true
            ;;
        r)
            role="$OPTARG"
            ;;
        h)
            usb_usage
            ;;
        ?)
            usb_usage
            ;;
    esac
done

case "$role" in
    "otg")
        if [ "$built_in" != "true" ]; then
            insmod_otg_ko
        fi
        deactive_device
        usbd_acc_init
        active_device
        /bin/adbd &
        ;;
    "usbh_msc")
        terminate_acc_release
        if [ "$built_in" != "true" ]; then
            rmmod_class
            insmod_usbh_msc_ko
        fi
        deactive_device
        usbh_msc_init
        ;;
    "usbd_adb")
        terminate_acc_release
        if [ "$built_in" != "true" ]; then
            rmmod_class
            insmod_usbd_adb_ko
        fi
        deactive_device
        usbd_acc_init 2
        active_device
        /bin/adbd &
        ;;
    *)
        usb_usage
        ;;
esac