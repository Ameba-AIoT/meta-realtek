FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:prepend = " \
    file://defconfig \
    file://0001-download-only.patch \
    file://11-swupdate-boot-args \
"

do_install:append() {
    install -m 0644 ${WORKDIR}/11-swupdate-boot-args ${D}${libdir}/swupdate/conf.d/
}
