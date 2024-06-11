SUMMARY = "User-space test for Realtek Ameba GPIO based on sysfs"
DESCRIPTION = "User-space test for Realtek Ameba GPIO based on sysfs"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/tests/gpio/user/sysfs"

FILESPATH = "${RTKDIR}/tests/gpio/user/sysfs:"
SRC_URI = "file://rtk_gpio_sysfs_test.sh"

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
    install ${B}/rtk_gpio_sysfs_test ${D}${base_bindir}
    install -m 755 ${WORKDIR}/rtk_gpio_sysfs_test.sh ${D}${base_bindir}
}

INSANE_SKIP:${PN} += "file-rdeps"
PACKAGE_ARCH = "${MACHINE_ARCH}"
