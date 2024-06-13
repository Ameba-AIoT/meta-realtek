DESCRIPTION = "Realtek Base Commands Packagegroup"
LICENSE = "CLOSED"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = "\
    efuse \
    otp-ipc \
    recovery-test \
    captouch \
    getevent \
"
