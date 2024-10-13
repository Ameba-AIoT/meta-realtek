SUMMARY = "System timer Test for Realtek Ameba"
DESCRIPTION = "System timer Test for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"
inherit externalsrc

EXTERNALSRC = "${RTKDIR}/tests/system_timer"

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
    install ${B}/rtk_system_timer_test ${D}${base_bindir}
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
