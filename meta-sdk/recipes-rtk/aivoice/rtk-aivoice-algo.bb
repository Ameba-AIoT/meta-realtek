SUMMARY = "AIVoice APP for Realtek Ameba"
DESCRIPTION = "AIVoice APP for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "CLOSED"

inherit externalsrc

EXTERNALSRC = "${RTKDIR}/development/apps/aivoice/"

AIVOICE_ALGO_LIB = "-L${S}/prebuilts/lib/ameba_linux -laivoice -lafe_kernel -lafe_res_2mic50mm -lkernel -lvad_v7_200K -lkws_xiaoqiangxiaoqiang_nihaoxiaoqiang_v4_300K -lasr_cn_v8_2M -lfst_cn_cmd_ac40 -lnnns_com_v7_35K -ltensorflow-lite -lNE10 -lcJSON -ltomlc99 -laivoice_hal"
AIVOICE_ALGO_INC = "-I${S}/include/"


EXTRA_OEMAKE = " \
    CROSS_COMPILE=${HOST_PREFIX} \
    -C ${S} O=${B} V=1\
"

CFLAGS +=" --sysroot=${STAGING_DIR_HOST}"
LDFLAGS += "${TUNE_CCARGS}"

do_compile() {
    oe_runmake all LIBAIVOICE_INC="${AIVOICE_ALGO_INC}" LIBAIVOICE_LIB="${AIVOICE_ALGO_LIB}"
}


do_install () {
    install -d ${D}${base_bindir}
    install ${B}/rtk_aivoice_algo ${D}${base_bindir}
}


PACKAGE_ARCH = "${MACHINE_ARCH}"
