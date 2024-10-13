SUMMARY = "Recovery Daemon for Realtek Ameba"
DESCRIPTION = "Recovery Daemon for Realtek Ameba"
SECTION = "cmds"
HOMEPAGE = ""
LICENSE = "CLOSED"

SRC_URI = "file://init"

inherit externalsrc update-rc.d

EXTERNALSRC = "${RTKDIR}/development/recovery/recoveryd"

CFLAGS +=" --sysroot=${STAGING_DIR_HOST}"
LDFLAGS += "${TUNE_CCARGS}"

EXTRA_OEMAKE = " \
    CROSS_COMPILE=${HOST_PREFIX} \
    -C ${S} O=${B} V=1\
"

INITSCRIPT_NAME = "recoveryd"

do_compile() {
    oe_runmake all
}

do_install () {
    install -d ${D}${base_bindir}
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/init ${D}${sysconfdir}/init.d/recoveryd
    cp ${S}/recoveryd ${D}${base_bindir}
}

do_clean() {
    oe_runmake clean
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
