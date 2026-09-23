# Smaller default thread-stack rlimit on this ~6.7MB XIP board. Applies to the
# login shell and everything started from it (wpa_supplicant, iperf3, ...).
ulimit -s 1024
