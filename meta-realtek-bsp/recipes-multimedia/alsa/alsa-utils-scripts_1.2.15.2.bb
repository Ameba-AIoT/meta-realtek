require alsa-utils.inc

SUMMARY = "Shell scripts that show help info and create ALSA configuration files"
PROVIDES = "alsa-utils-alsaconf"
RPROVIDES:${PN} += "alsa-utils-alsaconf alsa-utils-alsa-info alsa-utils-alsabat"

# Tarball unpacks to alsa-utils-${PV}, not alsa-utils-scripts-${PV}
S = "${UNPACKDIR}/alsa-utils-${PV}"

PACKAGES = "${PN}"
RDEPENDS:${PN} += "bash"

FILES:${PN} = "${sbindir}/alsaconf \
               ${sbindir}/alsa-info.sh \
               ${sbindir}/alsabat-test.sh \
              "

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${B}/alsaconf/alsaconf ${D}${sbindir}/
	install -m 0755 ${S}/alsa-info/alsa-info.sh ${D}${sbindir}/
	if ${@bb.utils.contains('PACKAGECONFIG', 'bat', 'true', 'false', d)}; then
		install -m 0755 ${S}/bat/alsabat-test.sh ${D}${sbindir}/
	fi
}
