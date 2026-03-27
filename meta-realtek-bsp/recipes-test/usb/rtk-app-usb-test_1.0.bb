SUMMARY = "Usb test for Realtek Ameba"
DESCRIPTION = "Usb test for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

FILESPATH = "${RTKDIR}/tests/usb/:"
SRC_URI = "file://rtk_usb_test.sh"

do_install () {
    install -d ${D}/bin
    install -m 755 ${UNPACKDIR}/rtk_usb_test.sh ${D}/bin/
}

INSANE_SKIP:${PN} += "file-rdeps"

PACKAGE_ARCH = "${MACHINE_ARCH}"
