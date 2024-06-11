SUMMARY = "STREAM for Realtek Ameba"
DESCRIPTION = "STREAM for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/tests/benchmark/STREAM"

EXTRA_OEMAKE = " \
    CC="${CC}" \
    -C ${S} O=${B} stream_c.exe\
"

do_compile() {
    export CFLAGS="${CFLAGS} --sysroot=${STAGING_DIR_HOST}"
    oe_runmake
}

do_install () {
    install -d ${D}${base_sbindir}
    install ${S}/stream_c.exe ${D}${base_sbindir}/stream_c
}

INSANE_SKIP:${PN}= "ldflags"

PACKAGE_ARCH = "${MACHINE_ARCH}"
