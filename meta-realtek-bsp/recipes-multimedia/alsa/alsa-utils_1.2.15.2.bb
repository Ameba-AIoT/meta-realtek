require alsa-utils.inc

# Only needed as the dynamic packaging was altered, remove on upgrade
PR = "r2"

# Ameba: reorganize 6/8-channel data into the dual-DMA (FIFO0/FIFO1) layout
# expected by sound/soc/realtek/dma.c when aplay runs in --mmap mode.
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://0001-aplay-ameba-dual-dma-6-8ch-mmap-reorg.patch"

# alsa-utils is an empty meta-package
FILES:${PN} = ""
ALLOW_EMPTY:${PN} = "1"

FILES:${PN}-alsabat      = "${sbindir}/alsabat-test.sh"
FILES:${PN}-alsactl      = "*/udev/rules.d/90-alsa-restore.rules */*/udev/rules.d/90-alsa-restore.rules ${systemd_unitdir} ${localstatedir}/lib/alsa ${datadir}/alsa/init/"
FILES:${PN}-alsatplg     = "${libdir}/alsa-topology"
FILES:${PN}-amidi        = "${bindir}/amidi ${bindir}/aplaymidi* ${bindir}/arecordmidi*"
FILES:${PN}-aplay        = "${bindir}/aplay ${bindir}/arecord"
FILES:${PN}-speaker-test = "${datadir}/sounds/alsa/"

SUMMARY:${PN}-aconnect       = "ALSA sequencer connection manager"
SUMMARY:${PN}-alsabat        = "Command-line sound tester for ALSA sound card driver"
SUMMARY:${PN}-alsactl        = "Saves/restores ALSA-settings in /etc/asound.state"
SUMMARY:${PN}-alsaloop       = "ALSA PCM loopback utility"
SUMMARY:${PN}-alsamixer      = "ncurses-based control for ALSA mixer and settings"
SUMMARY:${PN}-alsatplg       = "Converts topology text files into binary format for kernel"
SUMMARY:${PN}-alsaucm        = "ALSA Use Case Manager"
SUMMARY:${PN}-amidi          = "Miscellaneous MIDI utilities for ALSA"
SUMMARY:${PN}-amixer         = "Command-line control for ALSA mixer and settings"
SUMMARY:${PN}-aplay          = "Play (and record) sound files using ALSA"
SUMMARY:${PN}-aseqdump       = "Shows the events received at an ALSA sequencer port"
SUMMARY:${PN}-aseqnet        = "Network client/server for ALSA sequencer"
SUMMARY:${PN}-aseqsend       = "Send arbitrary messages to ALSA seqencer port"
SUMMARY:${PN}-axfer          = "Transfer audio data frames"
SUMMARY:${PN}-iecset         = "ALSA utility for setting/showing IEC958 (S/PDIF) status bits"
SUMMARY:${PN}-nhlt-dmic-info = "Dumps microphone array information from ACPI NHLT table"
SUMMARY:${PN}-speaker-test   = "ALSA surround speaker test utility"

RRECOMMENDS:${PN}-alsactl = "alsa-states"

RPROVIDES:${PN}-alsabat += "${PN}-alsabat-test"
RPROVIDES:${PN}-aplay += "${PN}-arecord"
RPROVIDES:${PN}-amidi += "${PN}-aplaymidi ${PN}-aplaymidi2 ${PN}-arecordmidi ${PN}-arecordmidi2"

do_install:append() {
	# If udev is disabled, we told configure to install the rules
	# in /unwanted, so we can remove them now. If udev is enabled,
	# then /unwanted won't exist and this will have no effect.
	rm -rf ${D}/unwanted

	# bash-dependent scripts are shipped by the separate alsa-utils-scripts
	# recipe so the main alsa-utils package does not pull bash into rootfs.
	rm -f ${D}${sbindir}/alsaconf
	rm -f ${D}${sbindir}/alsa-info.sh
	rm -f ${D}${sbindir}/alsabat-test.sh
}

python populate_packages:prepend() {
    pn = d.getVar("PN")
    packages = do_split_packages(d, d.getVar("bindir"), r"^([^.]+).*$", pn + "-%s", "alsa-utils tool %s", extra_depends="")
    packages += do_split_packages(d, d.getVar("sbindir"), r"^([^.]+).*$", pn + "-%s", "alsa-utils tool %s", extra_depends="")
    d.setVar("RDEPENDS:" + pn, " ".join(packages))
}

PACKAGES_DYNAMIC = "^${PN}-.*"
