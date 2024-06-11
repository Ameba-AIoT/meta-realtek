#!/bin/sh
#
# SPDX-License-Identifier: GPL-2.0-only
#

. /etc/default/rcS

[ "$ROOTFS_READ_ONLY" = "no" ] && exit 0

. /etc/init.d/overlay.sh
