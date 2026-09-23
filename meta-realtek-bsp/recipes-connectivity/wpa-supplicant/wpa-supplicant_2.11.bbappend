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

# vd3: shrink wpa_supplicant to fit the 8MB rootfs -- drop dbus + openssl
# (libcrypto ~3.5MB) and use a minimal vd3-defconfig (WPA2/WPA3-Personal, internal crypto).
SRC_URI:append:rtl8730eah-vd3 = " file://vd3-defconfig file://vd3-wpa_supplicant.conf"
DEPENDS:remove:rtl8730eah-vd3 = "dbus"
PACKAGECONFIG:rtl8730eah-vd3 = ""

do_configure:rtl8730eah-vd3 () {
        ${MAKE} -C wpa_supplicant clean
        # No CONFIG_TLS line -> internal crypto, no openssl/gnutls linked.
        cp ${UNPACKDIR}/vd3-defconfig wpa_supplicant/.config
        rm -f wpa_supplicant/*.d wpa_supplicant/dbus/*.d
}

# Strip dbus .conf/.service files that stock do_install drops (no-dbus vd3 build).
# Also replace /etc/wpa_supplicant.conf: the shared conf-sane carries WPS/P2P
# global fields, and this build has no WPS -- unknown fields abort config parsing.
do_install:append:rtl8730eah-vd3 () {
        rm -rf ${D}${sysconfdir}/dbus-1
        rm -rf ${D}${datadir}/dbus-1
        install -m 600 ${UNPACKDIR}/vd3-wpa_supplicant.conf ${D}${sysconfdir}/wpa_supplicant.conf
}
