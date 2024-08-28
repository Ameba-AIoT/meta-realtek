require recipes-test/kmod-common/kmod-common.inc

SUMMARY = "Kernel module timer test for Realtek Ameba"
DESCRIPTION = "Kernel module timer test for Realtek Ameba"

EXTERNALSRC = "${RTKDIR}/tests/timer_hw"
S = "${EXTERNALSRC}"

do_install () {
    install -d ${D}/lib/modules/
    install ${S}/kmod-timer-test.ko ${D}/lib/modules/
}
