SUMMARY = "RTKRCP_Config_CFU_Tool_V1.02_20241218"
DESCRIPTION = "RTKRCP_Config_CFU_Tool_V1.02_20241218"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/development/openthread/RTKRCP_Config_CFU_Tool_V1.02_20241218"

EXTRA_OEMAKE = " \
    CROSS_COMPILE=${HOST_PREFIX} \
    -C ${S} O=${B} V=1\
"

CFLAGS +=" --sysroot=${STAGING_DIR_HOST} ${TUNE_CCARGS}"
LDFLAGS += " --sysroot=${STAGING_DIR_HOST} ${TUNE_CCARGS}"

do_compile() {
    oe_runmake all
}

do_install () {
    install -d ${D}${bindir}
	install -d ${D}/lib/firmware/rtkcfu/8771HTV
	install ${EXTERNALSRC}/rtkcfu ${D}${bindir}
	install -m 755 ${RTKDIR}/development/openthread/8771HTV/config.txt ${D}/lib/firmware/rtkcfu/8771HTV
	install -m 755 ${RTKDIR}/development/openthread/8771HTV/8771HTV_Config.bin ${D}/lib/firmware/rtkcfu/8771HTV
	install -m 644 ${RTKDIR}/development/openthread/8771HTV/v0_0_97_0_RTL8771HTV_ImgPacketFile_Bank0_Lower_Stack_Patch.offer.bin ${D}/lib/firmware/rtkcfu/8771HTV
	install -m 644 ${RTKDIR}/development/openthread/8771HTV/v0_0_97_0_RTL8771HTV_ImgPacketFile_Bank0_Lower_Stack_Patch.payload.bin ${D}/lib/firmware/rtkcfu/8771HTV
	install -m 644 ${RTKDIR}/development/openthread/8771HTV/v0_0_250_6_RTL8771HTV_ImgPacketFile_Bank0_Rom_Patch.offer.bin ${D}/lib/firmware/rtkcfu/8771HTV
	install -m 644 ${RTKDIR}/development/openthread/8771HTV/v0_0_250_6_RTL8771HTV_ImgPacketFile_Bank0_Rom_Patch.payload.bin ${D}/lib/firmware/rtkcfu/8771HTV
	install -m 644 ${RTKDIR}/development/openthread/8771HTV/v1_0_4_1_RTL8771HTV_ImgPacketFile_Bank0_App.offer.bin ${D}/lib/firmware/rtkcfu/8771HTV
	install -m 644 ${RTKDIR}/development/openthread/8771HTV/v1_0_4_1_RTL8771HTV_ImgPacketFile_Bank0_App.payload.bin ${D}/lib/firmware/rtkcfu/8771HTV
	install -m 644 ${RTKDIR}/development/openthread/8771HTV/v1_2_4_0_RTL8771HTV_ImgPacketFile_Bank0_FSBL.offer.bin ${D}/lib/firmware/rtkcfu/8771HTV
	install -m 644 ${RTKDIR}/development/openthread/8771HTV/v1_2_4_0_RTL8771HTV_ImgPacketFile_Bank0_FSBL.payload.bin ${D}/lib/firmware/rtkcfu/8771HTV
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES:${PN} += "${nonarch_base_libdir}/firmware/"