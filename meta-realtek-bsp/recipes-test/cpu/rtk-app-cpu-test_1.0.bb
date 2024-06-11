SUMMARY = "CPU Test for Realtek Ameba"
DESCRIPTION = "CPU Test for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

FILESPATH = "${RTKDIR}/tests/cpu/:"
SRC_URI = "file://rtk_cpu_test.sh"


do_install () {
    install -d ${D}${base_bindir}
    install -m 755 ${WORKDIR}/rtk_cpu_test.sh ${D}/bin
}

INSANE_SKIP:${PN} += "file-rdeps"

PACKAGE_ARCH = "${MACHINE_ARCH}"
