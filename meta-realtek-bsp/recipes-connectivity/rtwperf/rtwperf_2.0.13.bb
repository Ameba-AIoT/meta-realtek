DESCRIPTION = "rtwperf is a tool for realtek wifi certification"
SECTION = "console/network"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://COPYING;md5=e136a7b2560d80bcbf0d9b3e1356ecff"

inherit externalsrc
inherit autotools pkgconfig

EXTERNALSRC = "${RTKDIR}/development/cmds/rtwperf"
S = "${EXTERNALSRC}"

EXTRA_OECONF = "--exec-prefix=${STAGING_DIR_HOST}${layout_exec_prefix}"

PACKAGECONFIG ??= "${@bb.utils.contains('DISTRO_FEATURES', 'ipv6', 'ipv6', '', d)}"
PACKAGECONFIG[ipv6] = "--enable-ipv6,--disable-ipv6,"

do_install:append () {
    mv ${D}${bindir}/iperf ${D}${bindir}/rtwperf
}

CVE_PRODUCT = "iperf_project:iperf"

PACKAGE_ARCH = "${MACHINE_ARCH}"
