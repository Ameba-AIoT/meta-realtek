S = "${UNPACKDIR}"

do_install:rtl8730e-recovery() {
    install -d ${D}${sysconfdir}
    install -D -m 0644 ${UNPACKDIR}/inittab ${D}${sysconfdir}/inittab

    echo "console::respawn:-/bin/sh" >> ${D}${sysconfdir}/inittab
    echo "#tty2::askfirst:-/bin/sh" >> ${D}${sysconfdir}/inittab
    echo "#tty3::askfirst:-/bin/sh" >> ${D}${sysconfdir}/inittab
    echo "#tty4::askfirst:-/bin/sh" >> ${D}${sysconfdir}/inittab

}

# vd3 serial-console autologin: USE_VT=0 drops the stray second ttyS0 getty;
# the do_install below rewrites the getty into a passwordless root shell.
USE_VT:rtl8730eah-vd3 = "0"

do_install:append:rtl8730eah-vd3() {
    # -l /etc/vd3-login.sh (not /bin/sh): the wrapper sets the stack rlimit then
    # execs sh, since a getty-spawned shell is not a login shell and skips profile.
    sed -i 's#/sbin/getty -L#/sbin/getty -n -l /etc/vd3-login.sh -L#' ${D}${sysconfdir}/inittab
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
