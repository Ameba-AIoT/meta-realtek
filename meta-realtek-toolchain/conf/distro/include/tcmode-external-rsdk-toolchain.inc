#
# Configuration to use an external RSDK glibc binary toolchain wrapper
# 
# Copyright 2016-2023, Realtek Corp.
#

EXTERNAL_TOOLCHAIN ?= "UNDEFINED"

TOOLCHAIN_PATH_ADD = "${EXTERNAL_TOOLCHAIN}/bin:"
PATH =. "${TOOLCHAIN_PATH_ADD}"

RSDK_TARGET_SYS:arm = "arm-linux-gnueabi"
RSDK_TARGET_SYS:aarch64 = "aarch64-linux-gnu"
RSDK_TARGET_SYS = "${TARGET_SYS}"
TARGET_PREFIX = "${RSDK_TARGET_SYS}-"

RSDK_LIBDIR:arm = "lib"
RSDK_LIBDIR:aarch64 = "lib"
RSDK_LIBDIR = "lib"

GCCMULTILIB:forcevariable = "--disable-multilib"
IMAGE_LINGUAS:forcevariable = ""

# Blacklist toolchain recipes as a belt-and-suspenders way to use the external toolchain
SKIP_RECIPE[glibc] = "Using external toolchain"
SKIP_RECIPE[libgcc] = "Using external toolchain"
SKIP_RECIPE[gcc-cross] = "Using external toolchain"
SKIP_RECIPE[gcc-runtime] = "Using external toolchain"
SKIP_RECIPE[gcc-sanitizers] = "Using external toolchain"

PREFERRED_PROVIDER_linux-libc-headers = "external-rsdk-toolchain"
PREFERRED_PROVIDER_linux-libc-headers-dev = "external-rsdk-toolchain"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}gcc = "external-rsdk-toolchain"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}gcc-initial = "external-rsdk-toolchain"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}g++ = "external-rsdk-toolchain"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}binutils = "external-rsdk-toolchain"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}libc-for-gcc = "external-rsdk-toolchain"
PREFERRED_PROVIDER_virtual/${TARGET_PREFIX}compilerlibs = "external-rsdk-toolchain"
PREFERRED_PROVIDER_glibc = "external-rsdk-toolchain"
PREFERRED_PROVIDER_libgcc = "external-rsdk-toolchain"
PREFERRED_PROVIDER_virtual/libc = "external-rsdk-toolchain"
PREFERRED_PROVIDER_virtual/libc-locale = "external-rsdk-toolchain"
PREFERRED_PROVIDER_virtual/libintl = "external-rsdk-toolchain"
PREFERRED_PROVIDER_virtual/libiconv = "external-rsdk-toolchain"
PREFERRED_PROVIDER_virtual/crypt = "external-rsdk-toolchain"
PREFERRED_PROVIDER_glibc-thread-db = "external-rsdk-toolchain"
PREFERRED_PROVIDER_glibc-mtrace = "external-rsdk-toolchain"
PREFERRED_PROVIDER_libc-mtrace = "external-rsdk-toolchain"
PREFERRED_PROVIDER_virtual/linux-libc-headers = "external-rsdk-toolchain"
PREFERRED_PROVIDER_binutils-cross-${TARGET_ARCH} = "external-rsdk-toolchain"


TARGET_CPPFLAGS:prepend = " -isystem${EXTERNAL_TOOLCHAIN}/${RSDK_TARGET_SYS}/include "
TARGET_LDFLAGS:prepend = " -L${EXTERNAL_TOOLCHAIN}/${RSDK_TARGET_SYS}/lib -Wl,-rpath-link,${EXTERNAL_TOOLCHAIN}/${RSDK_TARGET_SYS}/lib "

TOOLCHAIN_OPTIONS = " --sysroot=${STAGING_DIR_HOST}"

DISTRO_FEATURES_LIBC = "ipv4 ipv6 libc-backtrace libc-big-macros libc-bsd libc-cxx-tests libc-catgets libc-crypt \
			libc-crypt-ufc libc-db-aliases libc-envz libc-fcvt libc-fmtmsg libc-fstab libc-ftraverse \
			libc-getlogin libc-idn libc-inet-anl libc-libm libc-libm-big \
			libc-locales libc-locale-code libc-charsets \
			libc-memusage libc-nis libc-nsswitch libc-rcmd libc-rtld-debug libc-spawn libc-streams libc-sunrpc \
			libc-utmp libc-utmpx libc-wordexp libc-posix-clang-wchar libc-posix-regexp libc-posix-regexp-glibc \
			libc-posix-wchar-io"

ENABLE_BINARY_LOCALE_GENERATION = "0"
GLIBC_INTERNAL_USE_BINARY_LOCALE = "precompiled"
LIBCOVERRIDE = ":libc-glibc"

ERROR_QA[type] ?= "list"
python toolchain_metadata_setup () {
    import subprocess
    if not isinstance(e, bb.event.ConfigParsed):
        return

    d = e.data
    l = d.createCopy()
    l.finalize()
    oe_import(l)

    external_toolchain = l.getVar('EXTERNAL_TOOLCHAIN', True)
    if not external_toolchain or external_toolchain == 'UNDEFINED':
        bb.fatal("Error: EXTERNAL_TOOLCHAIN must be set to the path to your rsdk toolchain")

    if not os.path.exists(external_toolchain):
        bb.fatal("Error: EXTERNAL_TOOLCHAIN path '%s' does not exist" % external_toolchain)

    # The external toolchain may not have been built with the oe-core preferred
    # gnu hash setting, so ensure that the corresponding sanity check is not an error.
    error_qa = oe.data.typed_value('ERROR_QA', l)
    if 'ldflags' in error_qa:
        error_qa.remove('ldflags')
        d.setVar('ERROR_QA', ' '.join(error_qa))
}
addhandler toolchain_metadata_setup

def populate_toolchain_links(d):
    import errno
    import os
    from glob import glob

    d = d.createCopy()
    d.finalize()

    pattern = bb.data.expand('${EXTERNAL_TOOLCHAIN}/bin/${TARGET_PREFIX}*', d)
    files = glob(pattern)
    if not files:
        bb.fatal("Unable to populate toolchain binary symlinks")

    bindir = d.getVar('STAGING_BINDIR_TOOLCHAIN', True)
    bb.mkdirhier(bindir)
    for f in files:
        base = os.path.basename(f)
        newpath = os.path.join(bindir, base)
        try:
            os.symlink(f, newpath)
        except OSError as exc:
            if exc.errno == errno.EEXIST:
                break
            bb.fatal("Unable to populate toolchain binary symlink for %s: %s" % (newpath, exc))

require conf/distro/include/external-rsdk-toolchain-versions.inc
