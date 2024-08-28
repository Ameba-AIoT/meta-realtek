# Copyright 2023 Realtek.
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "This is the basic core image"

LICENSE = "MIT"

#IMAGE_FEATURES += " \
#    ssh-server-dropbear \
#"

IMAGE_INSTALL += " \
    packagegroup-core-boot \
    packagegroup-rtk-network \
    packagegroup-rtk-multimedia \
    packagegroup-rtk-commands \
"

IMAGE_INSTALL += " \
    adbd \
    recoveryd \
    tinyalsa \
    alsa-lib \
    alsa-utils \
    bluez5 \
    hciattach \
    rtlbtmp \
    udev-extraconf \
    rtk-rc-local \
    lvgl \
    lv-drivers \
    ${@bb.utils.contains('DISTRO_FEATURES', 'rtk-fwk-full', 'packagegroup-rtk-test rtk-gui', '', d)} \
"

IMAGE_INSTALL:remove:rtl8730eah-va6 = " \
    packagegroup-rtk-multimedia \
    rtk-gui \
    lvgl \
    lv-drivers \
"

inherit core-image

ROOTFS_POSTPROCESS_COMMAND += '${@bb.utils.contains("IMAGE_FEATURES", "read-only-rootfs-delayed-postinsts", "remove_unneeded_files; ", "",d)}'

remove_unneeded_files() {
    rm -rf ${IMAGE_ROOTFS}/usr/src
    rm -rf ${IMAGE_ROOTFS}/usr/include
    rm -rf ${IMAGE_ROOTFS}/usr/share/mime
    rm -rf ${IMAGE_ROOTFS}/usr/share/alsa
    rm -rf ${IMAGE_ROOTFS}/usr/share/locale
    rm -rf ${IMAGE_ROOTFS}/usr/share/sounds
    rm -rf ${IMAGE_ROOTFS}/usr/lib/opkg
    rm -rf ${IMAGE_ROOTFS}/usr/lib/locale
    rm -rf ${IMAGE_ROOTFS}/usr/lib/libgio-2.0.so*
    rm -rf ${IMAGE_ROOTFS}/usr/lib/libxml2*
    rm -rf ${IMAGE_ROOTFS}/usr/lib/arm-rtk-linux-gnueabi
    rm -rf ${IMAGE_ROOTFS}/usr/bin/hcidump
    rm -rf ${IMAGE_ROOTFS}/usr/bin/btmon
}

export IMAGE_BASENAME = "ameba-image-core"
