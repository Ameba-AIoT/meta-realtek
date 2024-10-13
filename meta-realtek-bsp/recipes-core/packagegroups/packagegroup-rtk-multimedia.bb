DESCRIPTION = "Realtek MultiMedia Packagegroup"
LICENSE = "CLOSED"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = "\
    pipewire \
    pipewire-tools \
    pipewire-alsa \
    pipewire-modules-rt \
    wireplumber \
    libwireplumber \
"
