SUMMARY = "ADC Test for Realtek Ameba"
DESCRIPTION = "ADC Test for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

FILESPATH = "${RTKDIR}/tests/adc/:"
SRC_URI = "file://rtk_adc_test.sh"

EXTERNALSRC = "${RTKDIR}/tests/adc"

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
    install ${B}/rtk_adc_test ${D}${base_bindir}
    install -m 755 ${WORKDIR}/rtk_adc_test.sh ${D}/bin
}

INSANE_SKIP:${PN} += "file-rdeps"

PACKAGE_ARCH = "${MACHINE_ARCH}"
