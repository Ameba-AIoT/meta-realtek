SUMMARY = "Bluetooth MP Tools for Realtek Ameba"
DESCRIPTION = "Bluetooth MP Tools for Realtek Ameba"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/development/bluetooth/rtlbtmp"

do_install () {
    install -d ${D}${bindir}
    cp -fr ${S}/bin/rtlbtmp* ${D}${bindir}
}

INSANE_SKIP:${PN}= "ldflags"

PACKAGE_ARCH = "${MACHINE_ARCH}"
