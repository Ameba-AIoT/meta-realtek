# vd3: drop openssl PACKAGECONFIG (libcrypto ~3.5MB) to fit the 8MB rootfs;
# only iperf3's optional RSA client mode needs it, not throughput testing.
PACKAGECONFIG:rtl8730eah-vd3 = ""
