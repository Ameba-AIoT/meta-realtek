SUMMARY = "Pangu APP for Realtek Ameba"
DESCRIPTION = "Pangu APP for Realtek Ameba"
SECTION = "gui"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/development/apps/pangu_app/prebuilts"

do_install () {
    install -d ${D}${base_bindir}
    install -d ${D}${base_libdir}
    install -d ${D}/usr/local/ui/
    install -m 0755 ${S}/bin/pangu_app ${D}${base_bindir}
    cp -fr ${S}/lib/*.so ${D}${base_libdir}
    cp -fr ${S}/usr/local/ui/* ${D}/usr/local/ui/
}

INSANE_SKIP:${PN}+= "already-stripped"
INSANE_SKIP:${PN} += "file-rdeps"
INSANE_SKIP:${PN} += "dev-deps"
INSANE_SKIP:${PN}-dev+= "dev-elf"
INSANE_SKIP:${PN}-dev += "file-rdeps"

FILES:${PN}+= "/usr/local/ui"

PACKAGE_ARCH = "${MACHINE_ARCH}"
