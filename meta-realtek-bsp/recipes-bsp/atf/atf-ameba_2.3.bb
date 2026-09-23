SUMMARY = "ARM Trusted Firmware for Realtek Ameba"
DESCRIPTION = "ARM Trusted Firmware for Realtek Ameba"
LICENSE = "BSD-3-Clause"

# BL32: default OP-TEE; vd3 uses sp_min (built from the ATF tree) to reclaim the
# DRAM/flash OP-TEE would take. Scoped to vd3 so va6/va7/va8 keep OP-TEE.
AMEBA_AARCH32_SP = "optee"
AMEBA_AARCH32_SP:rtl8730eah-vd3 = "sp_min"

OPTEE_DEPENDS = "optee-os-ameba"
OPTEE_DEPENDS:rtl8730eah-vd3 = ""

OPTEE_COMPILE_DEP = "optee-os-ameba:do_deploy"
OPTEE_COMPILE_DEP:rtl8730eah-vd3 = ""

# OP-TEE BL32 binaries (empty for sp_min: no external secure payload).
BL32_OEMAKE = " \
    BL32=${DEPLOY_DIR_IMAGE}/optee/tee-header_v2.bin \
    BL32_EXTRA1=${DEPLOY_DIR_IMAGE}/optee/tee-pager_v2.bin \
    BL32_EXTRA2=${DEPLOY_DIR_IMAGE}/optee/tee-pageable_v2.bin \
"
BL32_OEMAKE:rtl8730eah-vd3 = ""

# PSRAM memory layout (secure DRAM at PSRAM top, 2MB-aligned NS base). Only the
# vd3 XIP board uses it; va6/va7/va8 keep ATF's original DDR layout.
AMEBA_PSRAM_LAYOUT = "0"
AMEBA_PSRAM_LAYOUT:rtl8730eah-vd3 = "1"

DEPENDS += "u-boot-ameba ${OPTEE_DEPENDS}"

do_compile[depends] += "u-boot-ameba:do_deploy ${OPTEE_COMPILE_DEP}"

inherit deploy
inherit externalsrc

AXF2BIN = "${RTKDIR}/yocto/meta-realtek/tools/verified_boot/axf2bin.py"
DEFAULT_KEY_DIR = "${RTKDIR}/yocto/meta-realtek/tools/verified_boot/security_keys/test/"

# requires CROSS_COMPILE set by hand as there is no configure script
export CROSS_COMPILE="${TARGET_PREFIX}"
export AMEBA_SDK="${RTKDIR}/firmware"

EXTERNALSRC = "${RTKDIR}/boot/arm-trusted-firmware"

EXTRA_OEMAKE += "V=1"
EXTRA_OEMAKE += "PLAT=amebasmart ARCH=aarch32 ARM_ARCH_MAJOR=8 AARCH32_SP=${AMEBA_AARCH32_SP} NEED_BL32=yes DEBUG=1 BUILD_BASE=${B}/build AMEBA_PSRAM_LAYOUT=${AMEBA_PSRAM_LAYOUT}"
EXTRA_OEMAKE += " \
    ${BL32_OEMAKE} \
    BL33=${DEPLOY_DIR_IMAGE}/u-boot.bin \
"

# Let the Makefile handle setting up the CFLAGS and LDFLAGS as it is
# a standalone application
CFLAGS[unexport] = "1"
AS[unexport] = "1"
LD[unexport] = "1"

LDFLAGS = "-z noexecstack"

do_configure[noexec] = "1"

do_compile() {
    oe_runmake_call -C ${S} O=${B} fiptool
    oe_runmake_call -C ${S} O=${B} all
    oe_runmake_call -C ${S} O=${B} fip 

    cp ${S}/prepend_header.sh ${B}/build/amebasmart/debug/
    cp ${S}/manifest.json ${B}/build/amebasmart/debug/
    cp ${S}/key.json ${B}/build/amebasmart/debug/

    cd ${B}/build/amebasmart/debug

    ./prepend_header.sh \
        ${B}/build/amebasmart/debug/bl1_sram.bin \
        __ca32_bl1_sram_start__ \
        ${B}/build/amebasmart/debug/bl1/bl1_sym.map

    ./prepend_header.sh \
        ${B}/build/amebasmart/debug/bl1.bin \
        __ca32_bl1_dram_start__ \
        ${B}/build/amebasmart/debug/bl1/bl1_sym.map

    ./prepend_header.sh \
        ${B}/build/amebasmart/debug/fip.bin \
        __ca32_fip_dram_start__ \
        ${B}/build/amebasmart/debug/bl1/bl1_sym.map

    cat ${B}/build/amebasmart/debug/bl1_sram_prepend.bin \
        ${B}/build/amebasmart/debug/bl1_prepend.bin \
        ${B}/build/amebasmart/debug/fip_prepend.bin \
        > ap_image_all.img

    # use the default manifest and key to create boot image
    python3 ${AXF2BIN} --extern-dir ${DEFAULT_KEY_DIR} encrypt manifest -i ap_image_all.img -o manifest.bin
    cat manifest.bin ap_image_all.img > fip.img
}

do_install() {
    install -d ${D}/boot
    install -m 644 ${B}/build/amebasmart/debug/fip.img ${D}/boot/fip.img
    install -m 644 ${B}/build/amebasmart/debug/ap_image_all.img ${D}/boot/boot_orig.img
}

do_deploy() {
    cp -fr ${D}/boot/fip.img ${DEPLOY_DIR_IMAGE}/
}
addtask deploy after do_install

FILES:${PN} += "/boot"

do_package_qa[noexec] = "1"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

PACKAGE_ARCH = "${MACHINE_ARCH}"
