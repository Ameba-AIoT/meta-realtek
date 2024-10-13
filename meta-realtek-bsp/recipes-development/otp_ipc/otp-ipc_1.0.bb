SUMMARY = "OTP CTRL command for Realtek Ameba"
DESCRIPTION = "OTP CTRL command for Realtek Ameba"
SECTION = "cmds"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/development/cmds/otp-ipc"

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
    install ${B}/otp-ipc ${D}${base_bindir}
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
