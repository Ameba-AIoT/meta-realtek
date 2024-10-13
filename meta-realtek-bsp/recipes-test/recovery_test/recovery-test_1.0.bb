SUMMARY = "Recovery Test for Realtek Ameba"
DESCRIPTION = "Recovery Test for Realtek Ameba"
SECTION = "cmds"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/development/recovery/test"

CFLAGS +=" --sysroot=${STAGING_DIR_HOST}"
LDFLAGS += "${TUNE_CCARGS}"

EXTRA_OEMAKE = " \
    CROSS_COMPILE=${HOST_PREFIX} \
    -C ${S} O=${B} V=1\
"

do_compile() {
    oe_runmake all
}

do_install () {
    install -d ${D}${base_bindir}
    cp ${S}/recovery_test ${D}${base_bindir}
}

do_clean() {
    oe_runmake clean
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
