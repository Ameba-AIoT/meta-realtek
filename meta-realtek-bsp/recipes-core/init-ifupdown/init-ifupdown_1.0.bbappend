FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI:preappend = "file://interfaces \
"

PACKAGE_ARCH = "${MACHINE_ARCH}"

