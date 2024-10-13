SUMMARY = "User-space test for Realtek Ameba GPIO based on chardev"
DESCRIPTION = "User-space test for Realtek Ameba GPIO based on chardev"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/tests/gpio/user/cdev"

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
    install ${B}/rtk_gpio_cdev_test ${D}${base_bindir}
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
