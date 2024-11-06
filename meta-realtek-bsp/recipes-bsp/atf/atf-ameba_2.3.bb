SUMMARY = "ARM Trusted Firmware for Realtek Ameba"
DESCRIPTION = "ARM Trusted Firmware for Realtek Ameba"
LICENSE = "BSD-3-Clause"

DEPENDS += "u-boot-ameba optee-os-ameba"

do_compile[depends] += "u-boot-ameba:do_deploy optee-os-ameba:do_deploy"

inherit deploy
inherit externalsrc

ELF2BIN = "${RTKDIR}/yocto/meta-realtek/tools/verified_boot/elf2bin"

# requires CROSS_COMPILE set by hand as there is no configure script
export CROSS_COMPILE="${TARGET_PREFIX}"

EXTERNALSRC = "${RTKDIR}/boot/arm-trusted-firmware"

EXTRA_OEMAKE += "V=1"
EXTRA_OEMAKE += "PLAT=amebasmart ARCH=aarch32 ARM_ARCH_MAJOR=8 AARCH32_SP=optee NEED_BL32=yes"
EXTRA_OEMAKE += " \
    BL32=${DEPLOY_DIR_IMAGE}/optee/tee-header_v2.bin \
    BL32_EXTRA1=${DEPLOY_DIR_IMAGE}/optee/tee-pager_v2.bin \
    BL32_EXTRA2=${DEPLOY_DIR_IMAGE}/optee/tee-pageable_v2.bin \
    BL33=${DEPLOY_DIR_IMAGE}/u-boot.bin \
"

# Let the Makefile handle setting up the CFLAGS and LDFLAGS as it is
# a standalone application
CFLAGS[unexport] = "1"
LDFLAGS[unexport] = "1"
AS[unexport] = "1"
LD[unexport] = "1"

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
        > boot_orig.img

    # use the dummy manifest and key to create boot image
    ${ELF2BIN} manifest manifest.json key.json boot_orig.img manifest.bin app
    cat manifest.bin boot_orig.img > boot.img
}

do_install() {
    install -d ${D}/boot
    install -m 644 ${B}/build/amebasmart/debug/boot.img ${D}/boot/boot.img
    install -m 644 ${B}/build/amebasmart/debug/boot_orig.img ${D}/boot/boot_orig.img
}

do_deploy() {
    cp -fr ${D}/boot/boot.img ${DEPLOY_DIR_IMAGE}/
}
addtask deploy after do_install

FILES:${PN} += "/boot"

do_package_qa[noexec] = "1"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

PACKAGE_ARCH = "${MACHINE_ARCH}"
