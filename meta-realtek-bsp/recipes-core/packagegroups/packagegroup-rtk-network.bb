DESCRIPTION = "Realtek Network Packagegroup"
LICENSE = "CLOSED"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = "\
    wpa-supplicant \
    dhcpcd \
    iw \
    wireless-tools \
    iptables \
    iperf2 \
    iperf3 \
    iwpriv \
    atwz \
    hostapd \
"
