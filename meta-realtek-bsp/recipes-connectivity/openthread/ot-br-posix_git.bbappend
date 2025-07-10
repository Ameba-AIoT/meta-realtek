FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LIC_FILES_CHKSUM = "file://LICENSE;md5=87109e44b2fda96a8991f27684a7349c \
                    file://third_party/cJSON/repo/LICENSE;md5=218947f77e8cb8e2fa02918dc41c50d0 \
                    file://third_party/http-parser/repo/LICENSE-MIT;md5=9bfa835d048c194ab30487af8d7b3778 \
                    file://third_party/openthread/repo/LICENSE;md5=543b6fe90ec5901a683320a36390c65f \
                    "
DEPENDS += "protobuf-native protobuf"
SRCREV = "671eac3a34dfb3e0b9799739fb2c62693eab2d0c"

SRC_URI = "gitsm://github.com/openthread/ot-br-posix.git;protocol=https;branch=main \
           file://0001-otbr-agent.service.in-remove-pre-exec-hook-for-mdns-.patch \
           file://0001-cmake-Disable-nonnull-compare-warning-on-gcc.patch \
           file://default-cxx-std.patch \
           file://0001-PATCH-otbr-agent.init.in-modify-lsb-related-function.patch \
           file://0002-PATCH-otbr-web.init.in-modify-lsb-related-functions.patch \
           file://0003-PATCH-scripts-use-proper-cmd-service-in-yocto-platfo.patch \
           file://0004-PATCH-openthread-makefile-add-macro-for-testharness.patch \
           file://0005-PATCH-run-rtkcfu-before-otbr-agent-start.patch \
           file://init \
           "

inherit update-rc.d

INITSCRIPT_NAME = "otbr_autostart"

do_install:append () {
	install -m 0755 ${WORKDIR}/init ${D}${sysconfdir}/init.d/otbr_autostart
	
	install -d ${D}${bindir}/otbr/script
	cp --preserve=mode,timestamps -R ${S}/script/* ${D}${bindir}/otbr/script
	
	install -d ${D}${bindir}/otbr/thread_cert
	cp --preserve=mode,timestamps ${S}/third_party/openthread/repo/tests/scripts/thread-cert/mcast6.py ${D}${bindir}/otbr/thread_cert
}

EXTRA_OECMAKE = "-DBUILD_TESTING=OFF \
                 -DOTBR_DBUS=ON \
                 -DOTBR_REST=ON \
                 -DOTBR_WEB=OFF \
                 -DCMAKE_LIBRARY_PATH=${libdir} \
                 -DOTBR_MDNS=avahi \
                 -DOTBR_BACKBONE_ROUTER=ON \
                 -DOTBR_BORDER_ROUTING=ON \
                 -DOTBR_SRP_ADVERTISING_PROXY=ON \
                 -DOTBR_BORDER_AGENT=ON \
                 -DOT_SPINEL_RESET_CONNECTION=ON \
                 -DOT_MLR=ON \
                 -DOT_SRP_SERVER=ON \
                 -DOT_ECDSA=ON \
                 -DOT_SERVICE=ON \
                 -DOTBR_DUA_ROUTING=ON \
                 -DOT_DUA=ON \
                 -DOT_BORDER_ROUTING_NAT64=ON \
                 -DOTBR_DNSSD_DISCOVERY_PROXY=ON \
                 -DOTBR_INFRA_IF_NAME=wlan0 \
                 -DOTBR_NO_AUTO_ATTACH=1 \
                 -DOT_REFERENCE_DEVICE=ON \
                 -DOT_DHCP6_CLIENT=ON \
                 -DOT_DHCP6_SERVER=ON \
				 -DOTBR_DNS_UPSTREAM_QUERY=ON \
				 -DOTBR_DNSSD_DISCOVERY_PROXY=ON \
				 -DOTBR_NAT64=ON \
				 -DOT_IP6_FRAGM=ON \
				 -DOT_COAP_OBSERVE=ON \
				 -DOT_SNTP_CLIENT=ON \
				 -DOT_JAM_DETECTION=ON \
				 -DOT_LINK_METRICS_INITIATOR=ON \
				 -DOT_MLE_MAX_CHILDREN=64 \
				 -DOTBR_RADIO_URL='spinel+hdlc+uart:///dev/ttyRTK2?uart-baudrate=2000000&uart-flow-control' \
                 "

RDEPENDS:${PN} += "bash"
