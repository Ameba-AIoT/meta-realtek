SUMMARY = "Optee Client for Realtek Ameba"
DESCRIPTION = "OPTEE Client for Realtek Ameba"
HOMEPAGE = ""
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=69663ab153298557a59c67a60a743e5b"

inherit autotools
inherit externalsrc

OPTEE_ARCH:arm = "arm32"

EXTERNALSRC = "${RTKDIR}/boot/optee/optee_client"

EXTRA_OEMAKE = " \
    -C ${S} O=${B} V=1 \
    PLATFORM=realtek \
    CFG_TEE_TA_LOG_LEVEL=1 \
    CFG_TEE_CORE_LOG_LEVEL=1 \
    CROSS_COMPILE=${HOST_PREFIX} \
    CFG_TEE_BENCHMARK=n \
"

do_install () {
    oe_runmake -C ${S} install

    install -D -p -m0644 ${B}/export/usr/lib/libteec.so.1.0.0 ${D}${libdir}/libteec.so.1.0.0
    ln -sf libteec.so.1.0.0 ${D}${libdir}/libteec.so.1
    ln -sf libteec.so.1.0.0 ${D}${libdir}/libteec.so

    install -D -p -m0644 ${B}/export/usr/lib/libckteec.so.0.1.0 ${D}${libdir}/libckteec.so.0.1.0
    ln -sf libckteec.so.0.1.0 ${D}${libdir}/libckteec.so.0
    ln -sf libckteec.so.0.1.0 ${D}${libdir}/libckteec.so

    install -D -p -m0755 ${B}/export/usr/sbin/tee-supplicant ${D}${bindir}/tee-supplicant

    cp -a ${B}/export/usr/include ${D}${includedir}
}

FILES:${PN} += "${libdir}/* ${includedir}/*"

INSANE_SKIP:${PN} = "ldflags dev-elf"
INSANE_SKIP:${PN}-dev = "ldflags dev-elf"

PACKAGE_ARCH = "${MACHINE_ARCH}"
