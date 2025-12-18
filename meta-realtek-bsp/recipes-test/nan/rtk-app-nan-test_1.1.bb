SUMMARY = "NAN Test for Realtek Ameba"
DESCRIPTION = "NAN Test for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

FILESPATH = "${RTKDIR}/tests/nan/:"
SRC_URI = "file://nan_test"

EXTERNALSRC = "${RTKDIR}/tests/nan"

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
    install ${B}/nan_vendor_wrapper ${D}${base_bindir}
    install -m 755 ${WORKDIR}/nan_test ${D}/bin
}

INSANE_SKIP:${PN} += "file-rdeps"

PACKAGE_ARCH = "${MACHINE_ARCH}"
