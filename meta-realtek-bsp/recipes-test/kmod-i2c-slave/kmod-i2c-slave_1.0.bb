require recipes-test/kmod-common/kmod-common.inc

SUMMARY = "Kernel module i2c slave test for Realtek Ameba"
DESCRIPTION = "Kernel module i2c slave test for Realtek Ameba"

EXTERNALSRC = "${RTKDIR}/tests/i2c-slave"
S = "${EXTERNALSRC}"

do_install () {
    install -d ${D}/lib/modules/
    install ${S}/kmod-i2c-slave-test.ko ${D}/lib/modules/
}
