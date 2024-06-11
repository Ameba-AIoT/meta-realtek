#
# Copyright 2016-2023, Realtek Corp.
#

def rsdk_run(d, cmd, *args):
    import bb.process
    import subprocess

    topdir = d.getVar('TOPDIR', True)
    toolchain_path = d.getVar('EXTERNAL_TOOLCHAIN', True)
    if not toolchain_path:
        return 'UNKNOWN', 'UNKNOWN'

    target_prefix = d.getVar('TARGET_PREFIX', True)
    path = os.path.join(toolchain_path, 'bin', target_prefix + cmd)
    args = [path] + list(args)

    return bb.process.run(args, cwd=topdir, stderr=subprocess.PIPE)

def rsdk_get_mlibdir(d):
    import os.path

    try:
        stdout, stderr = rsdk_run(d, 'gcc', '-print-libgcc-file-name')
    except bb.process.CmdError as exc:
        bb.error('Failed to obtain RSDK crtbegin output: %s' % exc)
        return 'UNKNOWN'
    else:
        libpath = os.path.dirname(os.path.abspath(stdout.splitlines()[-1]))
        return libpath

def rsdk_get_version(d):
    try:
        stdout, stderr = rsdk_run(d, 'gcc', '-v')
    except bb.process.CmdError as exc:
        bb.error('Failed to obtain RSDK toolchain version: %s' % exc)
        return 'UNKNOWN'
    else:
        last_line = stderr.splitlines()[-1]
        return last_line

# Extract the RSDK-x.y.z version
def rsdk_get_main_version(d):
    version = rsdk_get_version(d)
    bb.debug(2, 'Trying for parse version info from: %s' % version)
    if version != 'UNKNOWN':
        if version.split()[3] == '(Realtek':
            # gcc version 9.3.0 (Realtek ASDK64-9.3.0 Build 999+)
            return version.split()[4].split('-')[1]
        elif version.split()[4] == '(Realtek':
            # gcc version 9.3.0 20200111 (Realtek ASDK64-9.3.0 Build 999+)
            return version.split()[5].split('-')[1]
        else:
            bb.error('Failed to parse RSDK toolchain version from: %s' % version)
    else:
        return version

# Extract the x.y.z version from 'gcc version 4.9.1'
def rsdk_get_gcc_version(d):
    version = rsdk_get_version(d)
    if version != 'UNKNOWN':
        return version.split()[2]
    else:
        return version

def rsdk_get_libc_version(d):
    import os,bb
    syspath = bb.data.expand('${EXTERNAL_TOOLCHAIN}/${RSDK_TARGET_SYS}/', d)
    if not syspath:
        return 'UNKNOWN'

    libpath = syspath + bb.data.expand('${RSDK_LIBDIR}/${RSDK_TARGET_SYS}/', d)

    if os.path.exists(libpath):
        for file in os.listdir(libpath):
            if file.find('libc-') == 0:
                return file[5:-3]

    libpath = syspath + bb.data.expand('${RSDK_LIBDIR}/', d)

    if os.path.exists(libpath):
        for file in os.listdir(libpath):
            if file.find('libc-') == 0:
                return file[5:-3]

    libpath = syspath + '/usr/' + bb.data.expand('${RSDK_LIBDIR}/${RSDK_TARGET_SYS}/', d)

    if os.path.exists(libpath):
        for file in os.listdir(libpath):
            if file.find('libc-') == 0:
                return file[5:-3]

    libpath = syspath + '/usr/' + bb.data.expand('${RSDK_LIBDIR}/', d)

    if os.path.exists(libpath):
        for file in os.listdir(libpath):
            if file.find('libc-') == 0:
                return file[5:-3]
    return 'UNKNOWN'

def rsdk_get_libstdcpp_version(d):
    import os,bb
    libpath = bb.data.expand('${EXTERNAL_TOOLCHAIN}/${RSDK_LIBDIR}/', d)
    if not libpath:
        return 'UNKNOWN'

    if os.path.exists(libpath):
        for file in os.listdir(libpath):
            if file.find('libstdc++.so.') == 0:
                return file[12:]

    return 'UNKNOWN'

def rsdk_get_kernel_version(d):
    import os,bb
    syspath = bb.data.expand('${EXTERNAL_TOOLCHAIN}/${RSDK_TARGET_SYS}/', d)
    if not syspath:
        return 'UNKNOWN'

    vf = syspath + '/usr/include/linux/version.h'

    try:
        f = open(vf, 'r')
    except (OSError, IOError):
        return 'UNKNOWN'

    l = f.readlines();
    f.close();
    for s in l:
        if s.find('LINUX_VERSION_CODE') > 0:
            ver = int(s.split()[2])
            maj = ver / 65536
            ver = ver % 65536
            min = ver / 256
            ver = ver % 256
            return str(maj)+'.'+str(min)+'.'+str(ver)
    return 'UNKNOWN'

python external_rsdk_toolchain_version_handler () {
    if not isinstance(e, bb.event.ConfigParsed):
        return
    d = e.data
    ld = d.createCopy()
    ld.finalize()

    d.setVar('RSDK_VER_MAIN', rsdk_get_main_version(ld))
    d.setVar('RSDK_VER_GCC', rsdk_get_gcc_version(ld))
    d.setVar('RSDK_VER_LIBC', rsdk_get_libc_version(ld))
    d.setVar('RSDK_VER_LIBSTDCPP', rsdk_get_libstdcpp_version(ld))
    d.setVar('RSDK_VER_KERNEL', rsdk_get_kernel_version(ld))
    d.setVar('RSDK_MLIBDIR', rsdk_get_mlibdir(ld))
}
addhandler external_rsdk_toolchain_version_handler
