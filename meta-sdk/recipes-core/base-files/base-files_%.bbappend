FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://udhcpd.conf \
    file://usb.sh \
"

do_install:append:rtl8730eah-va6() {
    echo "/dev/mtdblock8          /mnt              jffs2      defaults              0  0" >> ${D}${sysconfdir}/fstab
    install -m 0644 ${WORKDIR}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0755 ${WORKDIR}/usb.sh ${D}${base_bindir}/usb.sh
}

do_install:append:rtl8730elh-va7() {
    echo "/dev/ubi1_0          /mnt                 ubifs      defaults              0  0" >> ${D}${sysconfdir}/fstab
    install -m 0644 ${WORKDIR}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0755 ${WORKDIR}/usb.sh ${D}${base_bindir}/usb.sh
}

do_install:append:rtl8730elh-va8() {
    echo "/dev/ubi1_0          /mnt                 ubifs      defaults              0  0" >> ${D}${sysconfdir}/fstab
    install -m 0644 ${WORKDIR}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0755 ${WORKDIR}/usb.sh ${D}${base_bindir}/usb.sh
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
