require recipes-test/kmod-common/kmod-common.inc

SUMMARY = "Kernel module crypto test for Realtek Ameba"
DESCRIPTION = "Kernel module crypto test for Realtek Ameba"

EXTERNALSRC = "${RTKDIR}/tests/crypto"
S = "${EXTERNALSRC}"

do_install () {
    install -d ${D}/lib/modules/
    install ${S}/kmod-crypto-test.ko ${D}/lib/modules/
}
