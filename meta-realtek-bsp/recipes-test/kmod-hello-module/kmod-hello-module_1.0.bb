require recipes-test/kmod-common/kmod-common.inc

SUMMARY = "Kernel hello module test for Realtek Ameba"
DESCRIPTION = "Kernel hello module test for Realtek Ameba"

EXTERNALSRC = "${RTKDIR}/tests/hello_module"
S = "${EXTERNALSRC}"

do_install () {
    install -d ${D}/lib/modules/
    install ${S}/kmod-hello-test.ko ${D}/lib/modules/
}
