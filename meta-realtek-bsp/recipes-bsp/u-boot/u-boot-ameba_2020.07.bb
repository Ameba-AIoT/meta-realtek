require recipes-bsp/u-boot/u-boot.inc

SUMMARY = "U-Boot bootloader for Realtek Ameba"
DESCRIPTION = "U-Boot for Realtek Ameba"
HOMEPAGE = ""
SECTION = "bootloaders"
DEPENDS += "bison-native"
LICENSE = "GPL-2.0-or-later"
#LIC_FILES_CHKSUM = "file://Licenses/README;md5=c7383a594871c03da76b3707929d2919"

#PROVIDES += "u-boot"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/boot/uboot"

PACKAGE_ARCH = "${MACHINE_ARCH}"
