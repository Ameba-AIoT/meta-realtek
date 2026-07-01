SUMMARY = "WiFi NAN Utility for Realtek Ameba"
DESCRIPTION = "WiFi NAN Utility for Realtek Ameba"
SECTION = "network"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

DEPENDS = "glib-2.0 json-c libnl"

EXTERNALSRC = "${RTKDIR}/tests/nan"

BB_GLIB_INC = "-I${STAGING_DIR_HOST}/usr/include/glib-2.0 -I${STAGING_DIR_HOST}/usr/lib/glib-2.0/include"
BB_GLIB_LIBS = "-lglib-2.0 -lgio-2.0"
BB_JSON_INC = "-I${STAGING_DIR_HOST}/usr/include/json-c/"
BB_JSON_LIB = "-L${STAGING_DIR_HOST}/usr/lib -ljson-c"

BB_NL3_INC = "-I${STAGING_DIR_HOST}/usr/include/libnl3"
BB_NL3_LIB = "-L${STAGING_DIR_HOST}/usr/lib -lnl-3"

CFLAGS += " --sysroot=${STAGING_DIR_HOST} ${TUNE_CCARGS}"
LDFLAGS += " --sysroot=${STAGING_DIR_HOST} ${TUNE_CCARGS}"

EXTRA_OEMAKE = " \
    CROSS_COMPILE=${HOST_PREFIX} \
    NAN_UTIL_SRC=${RTKDIR}/tests/nan \
    -C ${S} O=${B} V=1 \
"

do_compile() {
    oe_runmake all \
        GLIB_INC="${BB_GLIB_INC}" \
        GLIB_LIBS="${BB_GLIB_LIBS}" \
        JSON_INC="${BB_JSON_INC}" \
        JSON_LIBS="${BB_JSON_LIB}" \
        NL3_INC="${BB_NL3_INC}" \
        NL3_LIB="${BB_NL3_LIB}"
}

do_install () {
    install -d ${D}${bindir}
    install -d ${D}${libdir}

    install -m 0755 ${B}/nan_vendor_wrapper ${D}${bindir}/
    install -m 0755 ${B}/rtw_aware ${D}${bindir}/
    install -m 0755 ${B}/iw ${D}${bindir}/
    install -m 0755 ${B}/libnanapi.so ${D}${libdir}/
    install -m 0755 ${S}/script/nan_test ${D}${bindir}/

    # Install NAN config and shell scripts to /home/root/nan
    install -d ${D}/home/root/nan

    for f in ${S}/rtw_aware/*.conf; do
        if [ -f "$f" ]; then
            install -m 0644 "$f" ${D}/home/root/nan/
        fi
    done

    for f in ${S}/rtw_aware/*.sh; do
        if [ -f "$f" ]; then
            install -m 0755 "$f" ${D}/home/root/nan/
        fi
    done

    for f in ${D}/home/root/nan/*.conf ${D}/home/root/nan/*.sh; do
        if [ -f "$f" ]; then
            sed -i \
                -e 's/\bbash\b/sh/g' \
                -e 's/\bsudo[[:space:]]*//g' \
                -e 's#LD_LIBRARY_PATH=\./[[:space:]]\+\./rtw_aware#LD_LIBRARY_PATH=/usr/lib rtw_aware#g' \
                -e 's#"wpa_supplicant_dbg_para":[[:space:]]*"-dd"#"wpa_supplicant_dbg_para": ""#g' \
                "$f"
        fi
    done

}

do_clean() {
    oe_runmake clean
}

SOLIBS = ".so"
FILES_SOLIBSDEV = ""

FILES:${PN} += " \
    ${bindir}/nan_vendor_wrapper \
    ${bindir}/rtw_aware \
    ${bindir}/iw \
    ${libdir}/libnanapi.so \
    /home/root/nan \
    /home/root/nan/*.conf \
    /home/root/nan/*.sh \
"

FILES:${PN}-dev = "${includedir}"

INSANE_SKIP:${PN} += "32bit-time dev-so file-rdeps"

PACKAGE_ARCH = "${MACHINE_ARCH}"
