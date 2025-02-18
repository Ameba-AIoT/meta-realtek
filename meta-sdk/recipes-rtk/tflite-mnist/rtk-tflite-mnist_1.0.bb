SUMMARY = "Tflite Mnist for Realtek Ameba"
DESCRIPTION = "Tflite Mnist for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"
DEPENDS = "tensorflow-lite"
inherit externalsrc

EXTERNALSRC = "${RTKDIR}/development/apps/tflite_mnist"

TFLITE_LIB = "-L${STAGING_LIBDIR} -ltensorflowlite"
TFLITE_INC = "-I${STAGING_INCDIR}"

EXTRA_OEMAKE = " \
    CROSS_COMPILE=${HOST_PREFIX} \
    -C ${S} O=${B} V=1\
"

CFLAGS +=" --sysroot=${STAGING_DIR_HOST} "
LDFLAGS += "${TUNE_CCARGS}"

do_compile() {
    oe_runmake all LIBTFLITE_INC="${TFLITE_INC}" LIBTFLITE_LIB="${TFLITE_LIB}"
}

do_install () {
    install -d ${D}${base_bindir}
    install ${B}/rtk_tflite_mnist ${D}${base_bindir}
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
