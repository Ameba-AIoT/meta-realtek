SUMMARY = "ALSA sound utilities"
DESCRIPTION = "collection of small and often extremely powerful applications \
designed to allow users to control the various parts of the ALSA system."
HOMEPAGE = "http://www.alsa-project.org"
BUGTRACKER = "http://alsa-project.org/main/index.php/Bug_Tracking"
SECTION = "console/utils"
# Some parts are GPL-2.0-or-later, some are GPL-2.0-only (e.g. axfer, alsactl)
# so result is GPL-2.0-only
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=59530bdf33659b29e73d4adb9f9f6552 \
                    file://alsactl/utils.c;beginline=3;endline=18;md5=96cc06a4cebe5eb7975688ffb0e65642"
DEPENDS = "alsa-lib ncurses libsamplerate0 bash"

# alsa-utils specified in SRC_URI due to alsa-utils-scripts recipe
SRC_URI = "https://www.alsa-project.org/files/pub/utils/alsa-utils-${PV}.tar.bz2"
SRC_URI[sha256sum] = "7aaaafbfb01942113ec0c31e51f705910e81079205088ca2f8f137a3869e1a3a"

inherit autotools gettext pkgconfig manpages

PACKAGECONFIG ??= "udev"
# alsabat can be built also without fftw support (with reduced functionality).
PACKAGECONFIG[bat] = "--enable-bat,--disable-bat,fftwf"
PACKAGECONFIG[udev] = ",--with-udev-rules-dir=/unwanted/rules.d,udev"
PACKAGECONFIG[manpages] = "--enable-rst2man --enable-xmlto, --disable-rst2man --disable-xmlto, python3-docutils-native xmlto-native docbook-xml-dtd4-native docbook-xsl-stylesheets-native"
