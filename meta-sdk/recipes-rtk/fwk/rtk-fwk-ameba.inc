SUMMARY = "Frameworks for Realtek Ameba"
DESCRIPTION = "Frameworks for Realtek Ameba"
LICENSE = "CLOSED"

DEPENDS += "virtual/crypt"

inherit autotools
inherit externalsrc

EXTERNALSRC = "${RTKDIR}/fwk"
S = "${EXTERNALSRC}"

EXTRA_OEMAKE = " \
    -C ${S} V=sc \
    OUT_DIR="${B}" \
    EXTERNAL_TOOLCHAIN=true \
    TARGET_BUILD_VARIANT=eng \
    TARGET_BUILD_TYPE=release \
"

TARGET_CC_ARCH += "${LDFLAGS}"

do_install() {
    cp -fr ${B}/target/product/${PRODUCT}/system/* ${D}/
    cp -fr ${B}/target/product/${PRODUCT}/root/* ${D}/
}
