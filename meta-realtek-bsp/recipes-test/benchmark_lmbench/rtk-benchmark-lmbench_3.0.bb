SUMMARY = "Lmbench3 for Realtek Ameba"
DESCRIPTION = "Lmbench3 for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/tests/benchmark/lmbench3"

DEPENDS += "libtirpc"

CFLAGS += "--sysroot=${STAGING_DIR_HOST} -I${STAGING_INCDIR}/tirpc"
LDLIBS = "-L${STAGING_DIR_HOST}/usr/lib -ltirpc "
LDFLAGS += "${TUNE_CCARGS} ${LDLIBS}"

EXTRA_OEMAKE = " \
    -C ${S}/src \
    OS="arm-linux" \
    CC="${TARGET_PREFIX}gcc" \
    CFLAGS="${CFLAGS}" \
    LDFLAGS="${LDFLAGS}" \
    LDLIBS="${LDLIBS}" \
    BINDIR=${B} \
    lmbench \
"

do_compile() {
    oe_runmake
}

do_install () {
    install -d ${D}${base_sbindir}
    install ${B}/lat_mem_rd ${D}${base_sbindir}/
    install ${B}/bw_mem ${D}${base_sbindir}/
}

#INSANE_SKIP:${PN}= "ldflags"

PACKAGE_ARCH = "${MACHINE_ARCH}"
