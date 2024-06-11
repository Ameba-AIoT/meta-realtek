DESCRIPTION = "Linux Kernel for Realtek Ameba"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"
HOMEPAGE = "https://www.realtek.com"

LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

PE = "1"
PV = "${LINUX_VERSION}+git${SRCPV}"

require recipes-kernel/linux/linux-yocto.inc

KCONFIG_MODE = "--alldefconfig"
KBUILD_DEFCONFIG:rtl8730elh-va7 ?= "rtl8730elh_generic_defconfig"
KBUILD_DEFCONFIG:rtl8730elh-va8 ?= "rtl8730elh_generic_defconfig"

LINUX_VERSION_EXTENSION ?= ""

COMPATIBLE_MACHINE = "^rtl8730e$"
