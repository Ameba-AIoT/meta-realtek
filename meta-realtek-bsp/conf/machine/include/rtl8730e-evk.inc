MACHINEOVERRIDES =. "rtl8730e:"

DEFAULTTUNE ?= "cortexa32"
include conf/machine/include/arm/armv8a/tune-cortexa32.inc

IMAGE_FSTYPES += "tar.bz2 ubi"
#MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "kernel-image kernel-devicetree"
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS  += "kernel-modules"

# to remove kernel image in rootfs
RRECOMMENDS:${KERNEL_PACKAGE_NAME}-base = ""

UBI_VOLNAME ?= "rootfs"
MKUBIFS_ARGS = "-F -m 2048 -e 126976 -c 436 -j 380928"
UBINIZE_ARGS = "-m 2048 -p 131072 -s 2048 -O 2048"
UBI_IMGTYPE = "squashfs"
IMAGE_ROOTFS_ALIGNMENT = "2048"

SERIAL_CONSOLES ?= "115200;ttyS0 115200;ttyO0 115200;ttyAMA0"
#SERIAL_CONSOLES_CHECK = "${SERIAL_CONSOLES}"

PREFERRED_PROVIDER_virtual/kernel ?= "linux-ameba"
PREFERRED_VERSION_linux-yocto ?= "5.4%"

KERNEL_IMAGETYPE = "uImage"
KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"
KERNEL_DEVICETREE = "\
    rtl8730elh-va7-generic.dtb \
    rtl8730elh-va8-generic.dtb \
    rtl8730elh-va7-full.dtb \
    rtl8730elh-va8-full.dtb \
    rtl8730elh-va7-tests.dtb \
    rtl8730elh-va8-tests.dtb \
    rtl8730elh-va7-recovery.dtb \
    rtl8730elh-va8-recovery.dtb \
"

PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot-ameba"

UBOOT_ENTRYPOINT = "0x60388000"

UBOOT_SUFFIX = "bin"
