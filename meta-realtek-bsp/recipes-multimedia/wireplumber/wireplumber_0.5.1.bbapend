
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

RDEPENDS:libwireplumber += " \
    ${PN}-modules-default-nodes-api \
    ${PN}-modules-mixer-api \
    ${PN}-modules-lua-scripting \
    ${PN}-modules-metadata \
    ${PN}-modules-default-profile \
    ${PN}-modules-default-nodes \
    ${PN}-modules-file-monitor-api \
    ${PN}-modules-si-standard-link \
    ${PN}-modules-si-audio-adapter \
    ${PN}-modules-si-node \
    ${PN}-modules-si-audio-endpoint \
    ${PN}-modules-reserve-device \
    ${PN}-modules-portal-permissionstore \
"

FILES:${PN}-modules = "${libdir}/${PN}-${PV}/libwireplumber-*.so.*"