SUMMARY = "CTC command for Realtek Ameba"
DESCRIPTION = "CTC command for Realtek Ameba"
SECTION = "cmds"
HOMEPAGE = ""
LICENSE = "CLOSED"
DEPENDS = "cjson"
inherit externalsrc

EXTERNALSRC = "${RTKDIR}/development/cmds/captouch"

CFLAGS +=" --sysroot=${STAGING_DIR_HOST}"
LDFLAGS += "${TUNE_CCARGS}"

CTC_LIBJS_LIB = "-L${STAGING_DIR_HOST}/usr/lib -lcjson"
CTC_LIBJS_INC = "-I${STAGING_DIR_HOST}/usr/include/cjson/"

EXTRA_OEMAKE = " \
    CROSS_COMPILE=${HOST_PREFIX} \
    -C ${S} O=${B} V=1\
"

do_compile() {
    export CFLAGS LDFLAGS
    oe_runmake all LIBJS_INC=${CTC_LIBJS_INC} LIBJS_LIB="${CTC_LIBJS_LIB}"
}

do_install () {
    install -d ${D}${base_bindir}
    install ${B}/captouch ${D}${base_bindir}
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
