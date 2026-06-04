FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-mathops_arm-gate-armv8-intrinsic-on-FP_ARMV8.patch \
"
