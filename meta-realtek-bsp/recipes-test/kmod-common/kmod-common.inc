SUMMARY = "Kernel module test for Realtek Ameba"
DESCRIPTION = "Kernel module test for Realtek Ameba"
SECTION = "test"
HOMEPAGE = ""
LICENSE = "GPL-2.0-only"

inherit externalsrc
inherit module

DEPENDS = "virtual/kernel"

EXTRA_OEMAKE = "KERNELDIR=${STAGING_KERNEL_BUILDDIR}"
EXTRA_OEMAKE += "-C ${STAGING_KERNEL_BUILDDIR} M=${S}"

PACKAGE_ARCH = "${MACHINE_ARCH}"
