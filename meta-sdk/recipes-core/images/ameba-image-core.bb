DESCRIPTION = "This is the basic core image"

LICENSE = "MIT"

IMAGE_INSTALL += " \
    packagegroup-core-boot \
    kmod-hello-module \
    alsa-lib \
"

inherit core-image
export IMAGE_BASENAME = "ameba-image-core"
