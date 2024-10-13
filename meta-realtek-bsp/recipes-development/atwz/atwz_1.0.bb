SUMMARY = "ATWZ command for Realtek Ameba wifi"
DESCRIPTION = "ATWZ command for Realtek Ameba wifi"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/development/wifi/ATWZ"

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
    install -d ${D}${bindir}
    install ${B}/ATWZ ${D}${bindir}/ATWZ
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
