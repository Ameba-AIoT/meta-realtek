inherit externalsrc kernel

DESCRIPTION = "Linux Kernel 6.18"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"

FILESEXTRAPATHS:prepend := "${RTKDIR}/kernel/linux-6.18:"

EXTERNALSRC = "${RTKDIR}/kernel/linux-6.18"
S = "${EXTERNALSRC}"

KBUILD_DEFCONFIG:rtl8730eah-va6 ?= "rtl8730e_defconfig"
KBUILD_DEFCONFIG:rtl8730eam-va6 ?= "rtl8730e_defconfig"
KBUILD_DEFCONFIG:rtl8730eah-vd3 ?= "rtl8730e_xip_defconfig"
KBUILD_DEFCONFIG:rtl8730elm-va7 ?= "rtl8730e_defconfig"
KBUILD_DEFCONFIG:rtl8730elm-va8 ?= "rtl8730e_defconfig"
KBUILD_DEFCONFIG:rtl8730e-recovery ?= "rtl8730e_recovery_defconfig"

KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} O=${B} ${KBUILD_DEFCONFIG}"

# mkimage, for wrapping the XIP image so u-boot can boot it
DEPENDS += "${@bb.utils.contains('KERNEL_IMAGETYPE', 'xipImage', 'u-boot-tools-native', '', d)}"

# XIP flash image geometry, see rtl8730eah-vd3.conf
XIP_FLASH_LOAD_ADDR ?= ""
XIP_FLASH_PART_ADDR ?= ""

# Computed at parse time: bitbake's shell parser rejects $(( )) arithmetic.
XIP_FLASH_PAD_SIZE = "${@(int(d.getVar('XIP_FLASH_LOAD_ADDR'), 16) - int(d.getVar('XIP_FLASH_PART_ADDR'), 16) - 64) if (d.getVar('XIP_FLASH_LOAD_ADDR') and d.getVar('XIP_FLASH_PART_ADDR')) else ''}"

# Wrap xipImage with a uImage header at LOAD-0x40 and front-pad by (LOAD-PART-64)
# so flashing at PART lands the payload on LOAD -> u-boot bootm zero-copy path.
xip_deploy_flashable() {
    cd ${DEPLOYDIR}

    pad="${XIP_FLASH_PAD_SIZE}"
    if [ -z "$pad" ] || [ "$pad" -lt 0 ]; then
        bbfatal "XIP_FLASH_LOAD_ADDR (${XIP_FLASH_LOAD_ADDR}) must be >= XIP_FLASH_PART_ADDR (${XIP_FLASH_PART_ADDR}) + 64"
    fi

    mkimage -A arm -O linux -T kernel -C none \
            -a ${XIP_FLASH_LOAD_ADDR} -e ${XIP_FLASH_LOAD_ADDR} \
            -n "XIP Linux" -d xipImage xipImage.uimg

    head -c "$pad" /dev/zero | tr '\0' '\377' > xip_pad.bin
    cat xip_pad.bin xipImage.uimg > kernel.img
    rm -f xip_pad.bin

    # mkernel() ends with "cp -f uImage kernel.img"; provide uImage so it succeeds.
    cp -f kernel.img uImage

    bbnote "XIP flashable kernel.img: pad=$pad, payload lands at ${XIP_FLASH_LOAD_ADDR} when flashed at ${XIP_FLASH_PART_ADDR}"
}

do_deploy() {
    kernel_do_deploy

    if [ "${KERNEL_IMAGETYPE}" = "xipImage" ] && [ -n "${XIP_FLASH_LOAD_ADDR}" ] && [ -n "${XIP_FLASH_PART_ADDR}" ]; then
        xip_deploy_flashable
    fi
}

PACKAGE_ARCH="${MACHINE_ARCH}"
