require rtk-fwk-ameba.inc

PRODUCT = "full"

PROVIDES = "rtk-fwk-ameba-full"

DEPENDS += "lvgl drm lv-drivers"

do_compile() {
    oe_runmake TARGET_PRODUCT=${PRODUCT} TARGET_EXTERNAL_LD_DIRS="${STAGING_DIR_HOST}/usr/lib" TARGET_EXTERNAL_C_INCLUDES="${STAGING_DIR_HOST}/usr/include/lvgl ${STAGING_DIR_HOST}/usr/include/lvgl/lv_drivers"
}

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

INSANE_SKIP:${PN}= "ldflags"
INSANE_SKIP:${PN}-dev= "ldflags"
INSANE_SKIP:${PN}-dev+= "dev-elf"
INSANE_SKIP:${PN} += "build-deps"
INSANE_SKIP:${PN}+= "already-stripped"

FILES:${PN}+= "${base_libdir}/* /usr"

PACKAGE_ARCH = "${MACHINE_ARCH}"
