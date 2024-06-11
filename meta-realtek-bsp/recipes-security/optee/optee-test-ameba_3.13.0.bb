SUMMARY = "Optee Test for Realtek Ameba"
DESCRIPTION = "OPTEE Test for Realtek Ameba"
HOMEPAGE = ""
LICENSE = "BSD & GPL-2.0-only"

DEPENDS += "optee-os-ameba optee-client-ameba python3-pycryptodomex-native"

inherit python3native autotools
inherit externalsrc

EXTERNALSRC = "${RTKDIR}/boot/optee/optee_test"

TA_DEV_KIT_DIR ?= "${STAGING_INCDIR}/optee/export-user_ta"
OPTEE_CLIENT_EXPORT ?= "${STAGING_DIR_HOST}${prefix}"

EXTRA_OEMAKE = " \
    TA_DEV_KIT_DIR=${TA_DEV_KIT_DIR} \
    OPTEE_CLIENT_EXPORT=${OPTEE_CLIENT_EXPORT} \
    CROSS_COMPILE_HOST=${HOST_PREFIX} \
    CROSS_COMPILE_TA=${HOST_PREFIX} \
    CFG_TEE_BENCHMARK=n \
    WITH_OPENSSL=n \
    -C ${S} O=${B} V=1\
"

#LDFLAGS +="-L$(STAGING_LIBDIR)"

do_compile() {
    #cp -af ${S}/host/openssl/include/* ${STAGING_INCDIR}/
    #cp -af ${S}/host/openssl/lib/arm/* ${STAGING_LIBDIR}/

    export CFLAGS="${CFLAGS} --sysroot=${STAGING_DIR_HOST}"
    oe_runmake all
}

do_install () {
    install -d ${D}${bindir}
    install ${B}/xtest/xtest ${D}${bindir}

    install -d ${D}${nonarch_base_libdir}/optee_armtz
    find ${B}/ta -name '*.ta' | while read name; do
        install -m 444 $name ${D}${nonarch_base_libdir}/optee_armtz/
    done
}

FILES:${PN} += "${nonarch_base_libdir}/optee_armtz/ ${libdir}/tee-supplicant/plugins/"

DEBUG_OPTIMIZATION:append = " -Wno-error=maybe-uninitialized -Wno-deprecated-declarations"
FULL_OPTIMIZATION:append = " -Wno-error=maybe-uninitialized -Wno-deprecated-declarations"

PACKAGE_ARCH = "${MACHINE_ARCH}"
