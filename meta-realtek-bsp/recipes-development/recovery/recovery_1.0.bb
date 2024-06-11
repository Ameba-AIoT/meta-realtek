SUMMARY = "Recovery for Realtek Ameba"
DESCRIPTION = "Recovery for Realtek Ameba"
SECTION = "cmds"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

DEPENDS = "cjson"

EXTERNALSRC = "${RTKDIR}/development/recovery"

BB_LIBJS_LIB = "-L${STAGING_DIR_HOST}/usr/lib -lcjson"
BB_LIBJS_INC = "-I${STAGING_DIR_HOST}/usr/include/cjson/"

CFLAGS +=" --sysroot=${STAGING_DIR_HOST}"
LDFLAGS += "${TUNE_CCARGS}"

EXTRA_OEMAKE = " \
    CROSS_COMPILE=${HOST_PREFIX} \
    -C ${S} O=${B} V=1\
"

do_compile() {
    oe_runmake all LIBJS_INC=${BB_LIBJS_INC} LIBJS_LIB="${BB_LIBJS_LIB}"
}

do_install () {
    install -d ${D}${base_bindir}
    cp ${S}/recovery ${D}${base_bindir}
}

do_clean() {
    oe_runmake clean
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
