FILESEXTRAPATHS:prepend:= "${THISDIR}/${BPN}:"

SRC_URI:append:rtl8730elh-recovery =" \
    file://recovery_init.cfg \
    file://ubi.cfg \
"
SRC_URI:append:rtl8730elh-va8 =" \
    file://init.cfg \
    file://tools.cfg \
"
SRC_URI:append:rtl8730elh-va7 =" \
    file://init.cfg \
    file://tools.cfg \
"
