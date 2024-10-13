SUMMARY = "Spic test for Realtek Ameba"
DESCRIPTION = "Spic test for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

FILESPATH = "${RTKDIR}/tests/spic/:"
SRC_URI = "file://rtk_spic_test.sh"

do_install () {
    install -d ${D}/bin
    install -m 755 ${WORKDIR}/rtk_spic_test.sh ${D}/bin/
}

INSANE_SKIP:${PN} += "file-rdeps"

PACKAGE_ARCH = "${MACHINE_ARCH}"
