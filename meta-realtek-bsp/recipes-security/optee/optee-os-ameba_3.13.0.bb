SUMMARY = "Optee OS for Realtek Ameba"
DESCRIPTION = "OPTEE OS for Realtek Ameba"
HOMEPAGE = ""
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=c1f21c4f72f372ef38a5a4aee55ec173"

#FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

inherit autotools
inherit externalsrc

OPTEE_ARCH:arm = "arm32"

EXTERNALSRC = "${RTKDIR}/boot/optee/optee_os"
S = "${EXTERNALSRC}"

EXTRA_OEMAKE = " \
    -C ${S} O=${B} V=1 \
    PLATFORM=realtek \
    CFG_TEE_TA_LOG_LEVEL=1 \
    CFG_TEE_CORE_LOG_LEVEL=1 \
    CROSS_COMPILE=${HOST_PREFIX} \
    CROSS_COMPILE_core=${HOST_PREFIX} \
    CROSS_COMPILE_ta_arm64= \
    CFG_TEE_BENCHMARK=n \
"

#LDFLAGS +="${STAGING_LIBDIR}"

do_compile() {
    unset LDFLAGS
    export CFLAGS="${CFLAGS} --sysroot=${STAGING_DIR_HOST}"
    oe_runmake all
}

do_install () {
    install -d ${D}/lib/firmware/
    install -m 644 ${B}/core/*.bin ${D}/lib/firmware/

    # Install the TA devkit
    install -d ${D}/usr/include/optee/export-user_ta/
    cp -aR ${B}/export-ta_${OPTEE_ARCH}/* ${D}/usr/include/optee/export-user_ta/
}

do_deploy() {
    install -d ${DEPLOY_DIR_IMAGE}/optee/
    cp -fr ${B}/core/*.bin ${DEPLOY_DIR_IMAGE}/optee
}
addtask deploy after do_install

INHIBIT_PACKAGE_STRIP = "1"

FILES:${PN} = "${nonarch_base_libdir}/firmware/ ${nonarch_base_libdir}/optee_armtz/"
FILES:${PN}-staticdev = "${includedir}/optee/"
PACKAGE_ARCH = "${MACHINE_ARCH}"
