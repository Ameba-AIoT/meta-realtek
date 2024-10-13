SUMMARY = "SDIOH Test for Realtek Ameba"
DESCRIPTION = "SDIOH Test for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/tests/sdioh"

FILESPATH = "${RTKDIR}/tests/sdioh:"
SRC_URI = "file://rtk_sdioh_test.sh"

EXTRA_OEMAKE = " \
    CROSS_COMPILE=${HOST_PREFIX} \
    -C ${S} O=${B} V=1\
"

CFLAGS +=" --sysroot=${STAGING_DIR_HOST}"
LDFLAGS += "${TUNE_CCARGS}"

do_compile() {
    oe_runmake all
}

do_install () {
    install -d ${D}${base_bindir}
    install ${B}/rtk_sdioh_test ${D}${base_bindir}
    install -m 755 ${WORKDIR}/rtk_sdioh_test.sh ${D}${base_bindir}
}

INSANE_SKIP:${PN} += "file-rdeps"
PACKAGE_ARCH = "${MACHINE_ARCH}"
