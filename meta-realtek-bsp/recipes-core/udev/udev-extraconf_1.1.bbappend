FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
       file://mount.sh \
"

MOUNT_BASE = "/mnt/storage"

