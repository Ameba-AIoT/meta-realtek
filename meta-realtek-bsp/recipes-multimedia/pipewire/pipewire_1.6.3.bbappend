
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:prepend = " \
    file://0001-pipewire-conf.patch \
    file://0003-spa-alsa-ameba-dual-dma-6-8ch-reorg.patch \
"

PACKAGECONFIG:class-target:append = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'bluetooth', 'bluez-lc3', '', d)} \
"

RDEPENDS:libpipewire += " \
    ${PN}-modules-protocol-native \
    ${PN}-modules-spa-node-factory \
    ${PN}-modules-spa-device-factory \
    ${PN}-modules-adapter \
    ${PN}-modules-client-node \
    ${PN}-modules-client-device \
    ${PN}-modules-metadata \
    ${PN}-modules-link-factory \
    ${PN}-modules-session-manager \
    ${PN}-modules-access \
    ${PN}-modules-profiler \
    ${PN}-modules-loopback \
    ${PN}-modules-portal \
    ${PN}-spa-plugins-support \
    ${PN}-spa-plugins-dbus \
    ${PN}-spa-plugins-audioconvert \
    ${PN}-spa-plugins-alsa \
    ${PN}-spa-plugins-bluez5 \
    ${PN}-spa-plugins-codec-bluez5-sbc \
"
