FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:prepend = " \
    file://defconfig \
    file://init \
    file://hostapd.service \
"
