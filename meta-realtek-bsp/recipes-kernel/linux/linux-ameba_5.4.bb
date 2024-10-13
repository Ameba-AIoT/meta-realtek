#
# Copyright 2023, Realtek Semiconductor Corp.
#
inherit kernel
inherit externalsrc

DESCRIPTION = "Linux Kernel"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"

FILESEXTRAPATHS:prepend := "${RTKDIR}/kernel/linux-5.4:"

EXTERNALSRC = "${RTKDIR}/kernel/linux-5.4"
S = "${EXTERNALSRC}"

KBUILD_DEFCONFIG:rtl8730eah-va6 ?= "rtl8730elh_defconfig"
KBUILD_DEFCONFIG:rtl8730elh-va7 ?= "rtl8730elh_defconfig"
KBUILD_DEFCONFIG:rtl8730elh-va8 ?= "rtl8730elh_defconfig"
KBUILD_DEFCONFIG:rtl8730elh-recovery ?= "rtl8730elh_recovery_defconfig"

KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} O=${B} ${KBUILD_DEFCONFIG}"

do_deploy() {
    kernel_do_deploy
}

PACKAGE_ARCH="${MACHINE_ARCH}"
