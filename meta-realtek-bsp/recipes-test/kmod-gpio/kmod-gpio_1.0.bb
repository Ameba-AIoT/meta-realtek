require recipes-test/kmod-common/kmod-common.inc

SUMMARY = "Kernel module gpio test for Realtek Ameba"
DESCRIPTION = "Kernel module gpio test for Realtek Ameba"

EXTERNALSRC = "${RTKDIR}/tests/gpio/kernel"
S = "${EXTERNALSRC}"

do_install () {
    install -d ${D}/lib/modules/
    install ${S}/kmod-gpio-test.ko ${D}/lib/modules/
}
