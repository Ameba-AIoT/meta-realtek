# SPDX-License-Identifier: GPL-2.0-only
#
# cramfs-xip: read-only XIP rootfs via npitre mkcramfs -X (uncompressed
# page-aligned blocks that fs/cramfs remap_pfn_range()s straight from NOR).

IMAGE_TYPES += "cramfs-xip"

# -X passed TWICE: MMU-grade (4K) alignment required so cramfs_physmem_mmap()
# does remap_pfn_range(); a single -X aligns to 8B and falls back to page cache.
CRAMFS_XIP_ARGS ?= "-X -X -q"

IMAGE_CMD:cramfs-xip = " \
    mkcramfs ${CRAMFS_XIP_ARGS} ${EXTRA_IMAGECMD} \
        ${IMAGE_ROOTFS} ${IMGDEPLOYDIR}/${IMAGE_NAME}.cramfs-xip \
"

do_image_cramfs_xip[depends] += "cramfs-tools-native:do_populate_sysroot"
