SUMMARY = "GETEVENT command for Realtek Ameba" 
DESCRIPTION = "GETEVENT command for Realtek Ameba"
SECTION = "cmds"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/development/cmds/getevent"

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
    install ${B}/getevent ${D}${bindir}
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
