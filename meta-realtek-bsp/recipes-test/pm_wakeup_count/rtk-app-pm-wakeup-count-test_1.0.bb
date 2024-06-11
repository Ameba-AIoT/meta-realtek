SUMMARY = "PM_WAKEUP_COUNT Test for Realtek Ameba"
DESCRIPTION = "PM_WAKEUP_COUNT Test for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/tests/pm_wakeup_count"

FILESPATH = "${RTKDIR}/tests/pm_wakeup_count:"
SRC_URI = "file://rtk_pm_wakeup_test.sh"

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
    install ${B}/rtk_pm_wakeup_count_test ${D}${base_bindir}
    install ${WORKDIR}/rtk_pm_wakeup_test.sh ${D}${base_bindir}
}

INSANE_SKIP:${PN} += "file-rdeps"
PACKAGE_ARCH = "${MACHINE_ARCH}"
