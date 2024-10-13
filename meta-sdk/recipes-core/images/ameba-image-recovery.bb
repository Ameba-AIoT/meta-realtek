LICENSE = "CLOSED"

#inherit core-image
inherit image

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""
IMAGE_LINGUAS = ""

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
PACKAGE_INSTALL = "${IMAGE_INSTALL}"

IMAGE_ROOTFS_EXTRA_SPACE = "0"

LDCONFIGDEPEND = ""
ROOTFS_BOOTSTRAP_INSTALL = ""

# avoid circular dependencies
EXTRA_IMAGEDEPENDS = ""
KERNELDEPMODDEPEND = ""

COMPATIBLE_HOST = '(x86_64.*|i.86.*|arm.*|aarch64.*)-(linux.*|freebsd.*)'
