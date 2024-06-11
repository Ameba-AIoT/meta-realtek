S = "${WORKDIR}"

do_install:rtl8730elh-recovery() {
    install -d ${D}${sysconfdir}
    install -D -m 0644 ${WORKDIR}/inittab ${D}${sysconfdir}/inittab

    echo "console::respawn:-/bin/sh" >> ${D}${sysconfdir}/inittab
    echo "#tty2::askfirst:-/bin/sh" >> ${D}${sysconfdir}/inittab
    echo "#tty3::askfirst:-/bin/sh" >> ${D}${sysconfdir}/inittab
    echo "#tty4::askfirst:-/bin/sh" >> ${D}${sysconfdir}/inittab

}

PACKAGE_ARCH = "${MACHINE_ARCH}"

