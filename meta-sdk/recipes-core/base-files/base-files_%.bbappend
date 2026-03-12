FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://udhcpd.conf \
    file://usb.sh \
    file://fw_env.config \
    file://hwrevision \
    file://swupdate.cfg \
    file://swupdate-public.pem \
    file://postupdate.sh \
    file://recovery.sh \
    file://mdev.conf \
    file://udisk_add.sh \
    file://udisk_remove.sh \
"

do_install:append:rtl8730eah-va6() {
    echo "/dev/mtdblock8          /mnt              jffs2      defaults              0  0" >> ${D}${sysconfdir}/fstab
    install -m 0644 ${WORKDIR}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0755 ${WORKDIR}/usb.sh ${D}${base_bindir}/usb.sh
}

do_install:append:rtl8730eam-va6() {
    echo "/dev/mtdblock8          /mnt              jffs2      defaults              0  0" >> ${D}${sysconfdir}/fstab
    install -m 0644 ${WORKDIR}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0755 ${WORKDIR}/usb.sh ${D}${base_bindir}/usb.sh
}

do_install:append:rtl8730elm-va7() {
    echo "/dev/ubi1_0          /mnt                 ubifs      defaults              0  0" >> ${D}${sysconfdir}/fstab
    install -m 0644 ${WORKDIR}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
    install -m 0644 ${WORKDIR}/hwrevision ${D}${sysconfdir}/hwrevision
    install -m 0644 ${WORKDIR}/swupdate.cfg ${D}${sysconfdir}/swupdate.cfg
    install -m 0644 ${WORKDIR}/swupdate-public.pem ${D}${sysconfdir}/swupdate-public.pem
    install -m 0755 ${WORKDIR}/usb.sh ${D}${base_bindir}/usb.sh
    install -m 0755 ${WORKDIR}/postupdate.sh ${D}${bindir}/postupdate.sh
}

do_install:append:rtl8730elm-va8() {
    echo "/dev/ubi1_0          /mnt                 ubifs      defaults              0  0" >> ${D}${sysconfdir}/fstab
    install -m 0644 ${WORKDIR}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
    install -m 0644 ${WORKDIR}/hwrevision ${D}${sysconfdir}/hwrevision
    install -m 0644 ${WORKDIR}/swupdate.cfg ${D}${sysconfdir}/swupdate.cfg
    install -m 0644 ${WORKDIR}/swupdate-public.pem ${D}${sysconfdir}/swupdate-public.pem
    install -m 0755 ${WORKDIR}/usb.sh ${D}${base_bindir}/usb.sh
    install -m 0755 ${WORKDIR}/postupdate.sh ${D}${bindir}/postupdate.sh
}

do_install:rtl8730e-recovery() {
    install -d ${D}${sysconfdir}
    install -d ${D}${base_bindir}
    install -d ${D}${sysconfdir}/mdev
    install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
    install -m 0644 ${WORKDIR}/hwrevision ${D}${sysconfdir}/hwrevision
    install -m 0644 ${WORKDIR}/swupdate-public.pem ${D}${sysconfdir}/swupdate-public.pem
    install -m 0755 ${WORKDIR}/recovery.sh ${D}${base_bindir}/recovery.sh
    install -m 0755 ${WORKDIR}/mdev.conf ${D}${sysconfdir}/mdev.conf
    install -m 0755 ${WORKDIR}/udisk_add.sh ${D}${sysconfdir}/mdev/udisk_add.sh
    install -m 0755 ${WORKDIR}/udisk_remove.sh ${D}${sysconfdir}/mdev/udisk_remove.sh
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
