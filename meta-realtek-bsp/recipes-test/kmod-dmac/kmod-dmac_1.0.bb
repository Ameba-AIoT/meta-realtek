require recipes-test/kmod-common/kmod-common.inc

SUMMARY = "Kernel module dmac test for Realtek Ameba"
DESCRIPTION = "Kernel module dmac test for Realtek Ameba"

EXTERNALSRC = "${RTKDIR}/tests/dmac"
S = "${EXTERNALSRC}"

do_install () {
    install -d ${D}/lib/modules/
    install ${S}/kmod-dmac-test.ko ${D}/lib/modules/
    install ${S}/kmod-dmac-multi-test.ko ${D}/lib/modules/
}
