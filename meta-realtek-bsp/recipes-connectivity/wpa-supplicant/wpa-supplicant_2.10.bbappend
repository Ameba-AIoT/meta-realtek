
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:prepend = " \
    file://defconfig \
    file://wpa_supplicant.conf-sane \
"
