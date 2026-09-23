#!/bin/sh
# Console login wrapper: getty execs this instead of /bin/sh so the stack rlimit
# applies to the shell and everything started from it (wpa_supplicant, iperf3).
ulimit -s 1024
exec /bin/sh
