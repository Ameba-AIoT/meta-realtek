FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://udhcpd.conf \
    file://usb.sh \
"

do_install:append() {
    install -m 0644 ${WORKDIR}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0755 ${WORKDIR}/usb.sh ${D}${base_bindir}/usb.sh
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
