# Copyright 2023 Realtek.
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "This is the userdata image."

IMAGE_FSTYPES = "ubi"
MKUBIFS_ARGS = "-m 2048 -e 126976 -c 297 --jrn-size=380928"
UBINIZE_ARGS = "-m 2048 -p 131072"
UBI_IMGTYPE = "ubifs"

IMAGE_NAME_SUFFIX = ".userdata"

IMAGE_INSTALL = ""
IMAGE_LINGUAS = ""
PACKAGE_INSTALL = ""

inherit image
