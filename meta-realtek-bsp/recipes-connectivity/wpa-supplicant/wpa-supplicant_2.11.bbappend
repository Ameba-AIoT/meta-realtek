
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:prepend = " \
    file://defconfig \
    file://wpa_supplicant.conf-sane \
    ${@bb.utils.contains('DISTRO_FEATURES', 'matter', 'file://0001-enable-dbus-control-interface.patch;patchdir=${WORKDIR}', '', d)} \
"

do_configure () {
        ${MAKE} -C wpa_supplicant clean
        sed -e '/^CONFIG_TLS=/d' <${UNPACKDIR}/defconfig >wpa_supplicant/.config

        if ${@ bb.utils.contains('PACKAGECONFIG', 'openssl', 'true', 'false', d) }; then
                echo 'CONFIG_TLS=openssl' >>wpa_supplicant/.config
        elif ${@ bb.utils.contains('PACKAGECONFIG', 'gnutls', 'true', 'false', d) }; then
                echo 'CONFIG_TLS=gnutls' >>wpa_supplicant/.config
        sed -i -e 's/\(^CONFIG_DPP=\)/#\1/' \
               -e 's/\(^CONFIG_EAP_PWD=\)/#\1/' wpa_supplicant/.config
        fi

        # For rebuild
        rm -f wpa_supplicant/*.d wpa_supplicant/dbus/*.d
}
