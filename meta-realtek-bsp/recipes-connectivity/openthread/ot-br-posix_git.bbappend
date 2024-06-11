FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LIC_FILES_CHKSUM = "file://LICENSE;md5=87109e44b2fda96a8991f27684a7349c \
                    file://third_party/Simple-web-server/repo/LICENSE;md5=091ac9fd29d87ad1ae5bf765d95278b0 \
                    file://third_party/cJSON/repo/LICENSE;md5=218947f77e8cb8e2fa02918dc41c50d0 \
                    file://third_party/http-parser/repo/LICENSE-MIT;md5=9bfa835d048c194ab30487af8d7b3778 \
                    file://third_party/openthread/repo/LICENSE;md5=543b6fe90ec5901a683320a36390c65f \
                    "
DEPENDS += "protobuf-native protobuf"
SRCREV = "790dc775144e33995cd1cb2c15b348849cacf737"

SRC_URI += "file://0001-PATCH-otbr-agent.init.in-modify-lsb-related-function.patch \
		   file://0002-PATCH-otbr-web.init.in-modify-lsb-related-functions.patch \
		   file://0003-PATCH-scripts-use-proper-cmd-service-in-yocto-platfo.patch \
		   file://0004-PATCH-openthread-makefile-add-macro-for-testharness.patch \
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
                 -DOT_TREL=ON \
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
				 -DOT_MLE_MAX_CHILDREN=32 \
                 "

RDEPENDS:${PN} += "bash"
