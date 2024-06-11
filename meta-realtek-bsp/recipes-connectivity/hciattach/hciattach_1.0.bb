SUMMARY = "Bluetooth hciattach for Realtek Ameba"
DESCRIPTION = "Bluetooth hciattach for Realtek Ameba"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc update-rc.d

EXTERNALSRC = "${RTKDIR}/development/bluetooth/hciattach"

SRC_URI = "file://init"

EXTRA_OEMAKE = " \
    CROSS_COMPILE=${HOST_PREFIX} \
    -C ${S} O=${B} V=1\
"

CFLAGS +=" --sysroot=${STAGING_DIR_HOST}"
LDFLAGS += "${TUNE_CCARGS}"

INITSCRIPT_NAME = "rtk_hciattach"

do_compile() {
    oe_runmake all
}

do_install () {
    install -d ${D}${bindir}
    install -d ${D}${sysconfdir}/init.d
    install -d ${D}/lib/firmware/rtlbt
    install ${B}/rtk_hciattach ${D}${bindir}
    install -m 0755 ${WORKDIR}/init ${D}${sysconfdir}/init.d/rtk_hciattach
    install -m 644 ${RTKDIR}/development/bluetooth/bt_fw/rtl8730_fw ${D}/lib/firmware/rtlbt/
    install -m 644 ${RTKDIR}/development/bluetooth/bt_fw/rtl8730_mp_fw ${D}/lib/firmware/rtlbt/
    install -m 644 ${RTKDIR}/development/bluetooth/bt_fw/rtl8730_config_s0 ${D}/lib/firmware/rtlbt/
    install -m 644 ${RTKDIR}/development/bluetooth/bt_fw/rtl8730_config_s1 ${D}/lib/firmware/rtlbt/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES:${PN} += "${nonarch_base_libdir}/firmware/"