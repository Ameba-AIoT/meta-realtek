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

SRC_URI:append:rtl8730eah-vd3 = " file://vd3-ulimit.sh file://vd3-login.sh"

do_install:append:rtl8730eah-va6() {
    echo "/dev/mtdblock8          /mnt              jffs2      defaults              0  0" >> ${D}${sysconfdir}/fstab
    install -m 0644 ${S}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0755 ${S}/usb.sh ${D}${base_bindir}/usb.sh
}

do_install:append:rtl8730eam-va6() {
    echo "/dev/mtdblock8          /mnt              jffs2      defaults              0  0" >> ${D}${sysconfdir}/fstab
    install -m 0644 ${S}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0755 ${S}/usb.sh ${D}${base_bindir}/usb.sh
}

do_install:append:rtl8730eah-vd3() {
    # XIP bring-up: userdata (jffs2) auto-mount removed (mtd-rom shifts mtdblockN
    # indices); re-enable later by resolving the partition by label.
    install -m 0644 ${S}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0755 ${S}/usb.sh ${D}${base_bindir}/usb.sh

    # Mount /tmp as tmpfs: the rootfs is read-only cramfs-xip and the shared
    # fstab only lists /run and /var/volatile, so /tmp would stay read-only.
    echo "tmpfs                /tmp                 tmpfs      mode=1777,nodev,nosuid,size=512k   0  0" >> ${D}${sysconfdir}/fstab

    # Smaller default stack rlimit for the login shell and its children; rcS
    # cannot cover them because getty is spawned by init, not by rcS.
    install -d ${D}${sysconfdir}/profile.d
    install -m 0644 ${S}/vd3-ulimit.sh ${D}${sysconfdir}/profile.d/vd3-ulimit.sh

    # getty execs this instead of /bin/sh (see busybox-inittab bbappend): a
    # non-login shell never reads /etc/profile, so set the rlimit here.
    install -m 0755 ${S}/vd3-login.sh ${D}${sysconfdir}/vd3-login.sh
}

do_install:append:rtl8730elm-va7() {
    echo "/dev/ubi1_0          /mnt                 ubifs      defaults              0  0" >> ${D}${sysconfdir}/fstab
    install -m 0644 ${S}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0644 ${S}/fw_env.config ${D}${sysconfdir}/fw_env.config
    install -m 0644 ${S}/hwrevision ${D}${sysconfdir}/hwrevision
    install -m 0644 ${S}/swupdate.cfg ${D}${sysconfdir}/swupdate.cfg
    install -m 0644 ${S}/swupdate-public.pem ${D}${sysconfdir}/swupdate-public.pem
    install -m 0755 ${S}/usb.sh ${D}${base_bindir}/usb.sh
    install -m 0755 ${S}/postupdate.sh ${D}${bindir}/postupdate.sh
}

do_install:append:rtl8730elm-va8() {
    echo "/dev/ubi1_0          /mnt                 ubifs      defaults              0  0" >> ${D}${sysconfdir}/fstab
    install -m 0644 ${S}/udhcpd.conf ${D}${sysconfdir}/udhcpd.conf
    install -m 0644 ${S}/fw_env.config ${D}${sysconfdir}/fw_env.config
    install -m 0644 ${S}/hwrevision ${D}${sysconfdir}/hwrevision
    install -m 0644 ${S}/swupdate.cfg ${D}${sysconfdir}/swupdate.cfg
    install -m 0644 ${S}/swupdate-public.pem ${D}${sysconfdir}/swupdate-public.pem
    install -m 0755 ${S}/usb.sh ${D}${base_bindir}/usb.sh
    install -m 0755 ${S}/postupdate.sh ${D}${bindir}/postupdate.sh
}

do_install:rtl8730e-recovery() {
    install -d ${D}${sysconfdir}
    install -d ${D}${base_bindir}
    install -d ${D}${sysconfdir}/mdev
    install -m 0644 ${S}/fw_env.config ${D}${sysconfdir}/fw_env.config
    install -m 0644 ${S}/hwrevision ${D}${sysconfdir}/hwrevision
    install -m 0644 ${S}/swupdate.cfg ${D}${sysconfdir}/swupdate.cfg
    install -m 0644 ${S}/swupdate-public.pem ${D}${sysconfdir}/swupdate-public.pem
    install -m 0755 ${S}/recovery.sh ${D}${base_bindir}/recovery.sh
    install -m 0755 ${S}/mdev.conf ${D}${sysconfdir}/mdev.conf
    install -m 0755 ${S}/udisk_add.sh ${D}${sysconfdir}/mdev/udisk_add.sh
    install -m 0755 ${S}/udisk_remove.sh ${D}${sysconfdir}/mdev/udisk_remove.sh
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
