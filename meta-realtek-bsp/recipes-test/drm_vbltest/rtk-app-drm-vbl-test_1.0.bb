SUMMARY = "Drm Plane Test for Realtek Ameba"
DESCRIPTION = "Drm Plane for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"
DEPENDS = "drm"
inherit externalsrc

EXTERNALSRC = "${RTKDIR}/tests/drm/vbltest"

DRM_LIBDRM_LIB = "-L${STAGING_LIBDIR}/usr/lib -ldrm"
DRM_LIBDRM_INC = "-I${STAGING_DIR_HOST}/usr/include/ -I${STAGING_DIR_HOST}/usr/include/drm/ -I../"

EXTRA_OEMAKE = " \
    CROSS_COMPILE=${HOST_PREFIX} \
    -C ${S} O=${B} V=1\
"

CFLAGS +=" --sysroot=${STAGING_DIR_HOST}"
LDFLAGS += "${TUNE_CCARGS}"

do_compile() {
    oe_runmake all LIBDRM_INC="${DRM_LIBDRM_INC}" LIBDRM_LIB="${DRM_LIBDRM_LIB}"
}

do_install () {
    install -d ${D}${base_bindir}
    install ${B}/rtk_drm_vbl_test ${D}${base_bindir}
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
