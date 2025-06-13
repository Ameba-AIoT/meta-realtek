FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://mbedtls_config.h"

CFLAGS:append = " -DMBEDTLS_CONFIG_FILE='\"${WORKDIR}/mbedtls_config.h\"'"
