SUMMARY = "TfLite APP for Realtek Ameba"
DESCRIPTION = "TfLite APP for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "Apache-2.0"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/development/tflite/"

EXTRA_OEMAKE = " \
    CROSS_COMPILE=${HOST_PREFIX} \
    -C ${S} O=${B} V=1\
"

CFLAGS +=" --sysroot=${STAGING_DIR_HOST}"
LDFLAGS += "${TUNE_CCARGS}"

do_compile() {
    oe_runmake all
}


do_install () {
    install -d ${D}${base_bindir}
    install ${B}/rtk_tflite_algo ${D}${base_bindir}
}


PACKAGE_ARCH = "${MACHINE_ARCH}"
