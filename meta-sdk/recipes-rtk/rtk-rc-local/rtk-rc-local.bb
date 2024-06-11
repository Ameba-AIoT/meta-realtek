DESCRIPTION = "Extra files for ameba-image-core"
LICENSE = "CLOSED"

SRC_URI = " \
    file://rcS \
    file://rc.local \
"

S = "${WORKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "rc.local"
INITSCRIPT_PARAMS = "start 99 1 5 ."

do_install () {
    install -d ${D}/${sysconfdir}/init.d
    install -m 755 ${S}/rcS ${D}/${sysconfdir}/rc.local
    install -m 755 ${S}/rc.local ${D}/${sysconfdir}/init.d/rc.local

}

PACKAGE_ARCH = "${MACHINE_ARCH}"
