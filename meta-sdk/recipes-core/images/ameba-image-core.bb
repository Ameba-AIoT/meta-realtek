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
    ${@bb.utils.contains('DISTRO_FEATURES', 'rtk-fwk-full', 'packagegroup-rtk-test', '', d)} \
"

inherit core-image

export IMAGE_BASENAME = "ameba-image-core"
