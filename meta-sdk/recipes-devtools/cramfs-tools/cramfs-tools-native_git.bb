# SPDX-License-Identifier: GPL-2.0-only
#
# npitre/cramfs-tools: mkcramfs with -X (XIP, uncompressed ELF blocks) which
# util-linux's cramfs tool lacks; needed for fs/cramfs CONFIG_CRAMFS_MTD.

SUMMARY = "cramfs-tools (npitre) — mkcramfs with XIP (-X) support"
HOMEPAGE = "https://github.com/npitre/cramfs-tools"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=393a5ca445f6965873eca0259a17f833"

DEPENDS = "zlib-native"

# Third-party upstream, version-locked via git SRC_URI + SRCREV below.
SRC_URI = "git://github.com/npitre/cramfs-tools.git;protocol=https;branch=master"
SRCREV = "a95eecbf899479f8b3d65fb2822c5b7cbcdacfdd"

# S left to oe-core default (git checkout); setting it explicitly now errors.

inherit native

# Upstream ships a GNUmakefile building `mkcramfs` and `cramfsck` with -lz.
do_compile() {
    oe_runmake -C ${S} \
        CC="${BUILD_CC}" \
        CFLAGS="${BUILD_CFLAGS} -W -Wall -O2" \
        CPPFLAGS="-I${S}" \
        LDLIBS="-lz" \
        mkcramfs cramfsck
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/mkcramfs ${D}${bindir}/mkcramfs
    install -m 0755 ${S}/cramfsck ${D}${bindir}/cramfsck
}

# Build-host tool only.
BBCLASSEXTEND = ""
