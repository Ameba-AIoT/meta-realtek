# vd3: drop udev (board uses busybox-mdev, avoids pulling eudev ~1.6MB back in)
# and ipv6 (kernel built CONFIG_IPV6 off). dhcpcd uses its built-in dev monitoring.
PACKAGECONFIG:remove:rtl8730eah-vd3 = "udev ipv6"
