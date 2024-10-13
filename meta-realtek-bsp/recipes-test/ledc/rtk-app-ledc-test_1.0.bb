SUMMARY = "LEDC test for Realtek Ameba"
DESCRIPTION = "LEDC test for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

FILESPATH = "${RTKDIR}/tests/ledc/:"
SRC_URI = "file://rtk_ledc_test.sh"

do_install () {
    install -d ${D}/bin
    install -m 755 ${WORKDIR}/rtk_ledc_test.sh ${D}/bin/
}

INSANE_SKIP:${PN} += "file-rdeps"

PACKAGE_ARCH = "${MACHINE_ARCH}"



