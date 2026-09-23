FILESEXTRAPATHS:prepend:= "${THISDIR}/${BPN}:"

SRC_URI:append:rtl8730e-recovery =" \
    file://recovery_init.cfg \
    file://ubi.cfg \
"
SRC_URI:append:rtl8730elm-va8 =" \
    file://init.cfg \
    file://tools.cfg \
"
SRC_URI:append:rtl8730elm-va7 =" \
    file://init.cfg \
    file://tools.cfg \
"
SRC_URI:append:rtl8730eah-va6 =" \
    file://init.cfg \
    file://tools.cfg \
"
SRC_URI:append:rtl8730eam-va6 =" \
    file://init.cfg \
    file://tools.cfg \
"
SRC_URI:append:rtl8730eah-vd3 =" \
    file://init.cfg \
    file://tools.cfg \
    file://mdev.cfg \
    file://vd3-busybox-init.cfg \
    file://rcS-xip \
"

do_prepare_config:rtl8730e-recovery () {
	export KCONFIG_NOTIMESTAMP=1

	for i in 'CROSS' 'DISTRO FEATURES'; do echo "### $i"; done >> \
		${S}/.config
	sed -i -e '${configmangle}' ${S}/.config
	if test ${DO_IPv4} -eq 0 && test ${DO_IPv6} -eq 0; then
		# disable networking applets
		mv ${S}/.config ${S}/.config.oe-tmp
		awk 'BEGIN{net=0}
		/^# Networking Utilities/{net=1}
		/^#$/{if(net){net=net+1}}
		{if(net==2&&$0 !~ /^#/&&$1){print("# "$1" is not set")}else{print}}' \
		${S}/.config.oe-tmp > ${S}/.config
	fi
	sed -i 's/CONFIG_IFUPDOWN_UDHCPC_CMD_OPTIONS="-R -n"/CONFIG_IFUPDOWN_UDHCPC_CMD_OPTIONS="-R -b"/' ${S}/.config
	if [ -n "${DEBUG_PREFIX_MAP}" ]; then
		sed -i 's|${DEBUG_PREFIX_MAP}||g' ${S}/.config
	fi
}


# vd3: overwrite the shared /etc/init.d/rcS (which is the recovery script that
# reboot-loops on normal boot) with the minimal XIP rcS. recovery keeps its own.
do_install:append:rtl8730eah-vd3 () {
    install -D -m 0755 ${UNPACKDIR}/rcS-xip ${D}${sysconfdir}/init.d/rcS
}
