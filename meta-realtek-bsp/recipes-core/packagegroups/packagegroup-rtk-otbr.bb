DESCRIPTION = "Realtek OTBR Packagegroup"
LICENSE = "CLOSED"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = "\
    lsb-release \
    iputils \
    ipset \
    rsyslog \
    mdns \
    bind \
    dnsmasq \
    radvd \
    dpkg \
    resolvconf \
    coreutils \
    python3 \
    ot-br-posix \
"
