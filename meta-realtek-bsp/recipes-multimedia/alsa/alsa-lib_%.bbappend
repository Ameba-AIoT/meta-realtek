FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

RTK_PATCH = " \
    file://400-pcm-dmix.patch \
    file://500-audio-time-compile.patch \
"

SRC_URI:append = "${RTK_PATCH}"

PACKAGE_ARCH = "${MACHINE_ARCH}"
