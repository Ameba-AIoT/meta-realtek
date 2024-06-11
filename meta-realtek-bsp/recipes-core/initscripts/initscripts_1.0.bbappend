FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI:preappend = " \
    file://read-only-rootfs-hook.sh \
"

SRC_URI += "file://overlay.sh"

do_install:append() {
    install -m 0755 ${WORKDIR}/overlay.sh ${D}${sysconfdir}/init.d
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

