SUMMARY = "KM4 console for Realtek Ameba"
DESCRIPTION = "KM4 console for Realtek Ameba"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/development/cmds/km4_console"

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
    install ${B}/km4_console ${D}${bindir}
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
