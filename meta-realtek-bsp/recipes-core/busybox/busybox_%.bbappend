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
SRC_URI:append:rtl8730eah-va6 =" \
    file://init.cfg \
    file://tools.cfg \
"

do_prepare_config:rtl8730elh-recovery () {
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