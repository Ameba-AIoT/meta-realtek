
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:prepend = " \
    file://defconfig \
    file://wpa_supplicant.conf-sane \
    ${@bb.utils.contains('DISTRO_FEATURES', 'matter', 'file://0001-enable-dbus-control-interface.patch;patchdir=${WORKDIR}', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'matter', 'file://0001-eloop-epoll-use-default-select.patch;patchdir=${WORKDIR}', '', d)} \
"
