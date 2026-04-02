inherit externalsrc kernel

DESCRIPTION = "Linux Kernel 6.18"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"

FILESEXTRAPATHS:prepend := "${RTKDIR}/kernel/linux-6.18:"

EXTERNALSRC = "${RTKDIR}/kernel/linux-6.18"
S = "${EXTERNALSRC}"

KBUILD_DEFCONFIG:rtl8730eah-va6 ?= "rtl8730e_defconfig"
KBUILD_DEFCONFIG:rtl8730eam-va6 ?= "rtl8730e_defconfig"
KBUILD_DEFCONFIG:rtl8730elm-va7 ?= "rtl8730e_defconfig"
KBUILD_DEFCONFIG:rtl8730elm-va8 ?= "rtl8730e_defconfig"
KBUILD_DEFCONFIG:rtl8730e-recovery ?= "rtl8730e_recovery_defconfig"

KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} O=${B} ${KBUILD_DEFCONFIG}"

do_deploy() {
    kernel_do_deploy
}

PACKAGE_ARCH="${MACHINE_ARCH}"
