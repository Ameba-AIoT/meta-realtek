#!/bin/sh
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# Copyright (c) 2023 Realtek, LLC.

PROGNAME="envsetup.sh"

if [ -n "$BASH_SOURCE" ]; then
    THIS_SCRIPT=$BASH_SOURCE
    ROOTDIR="`readlink -f $BASH_SOURCE | xargs dirname`"
elif [ -n "$ZSH_NAME" ]; then
    THIS_SCRIPT=$0
    ROOTDIR="`readlink -f $0 | xargs dirname`"
else
    THIS_SCRIPT="$(pwd)/envsetup.sh"
    if [ ! -e "$THIS_SCRIPT" ]; then
        echo "Error: $THIS_SCRIPT doesn't exist!" >&2
        echo "Please run this script in envsetup.sh's directory." >&2
        exit 1
    fi
fi

if [ -z "$ZSH_NAME" ] && [ "$0" = "$THIS_SCRIPT" ]; then
    echo "Error: This script needs to be sourced. Please run as '. $THIS_SCRIPT'" >&2
    exit 1
fi

# Check if current user is root
if [ "$(whoami)" = "root" ]; then
    echo "ERROR: Do not use the BSP as root. Exiting..."
    unset ROOTDIR PROGNAME
    return
fi

OEROOT_DIR=${ROOTDIR}/sources/yocto/poky
RTK_META_DIR=${ROOTDIR}/sources/yocto/meta-realtek
RTK_PROJECT_DIR=${RTK_META_DIR}/meta-sdk/conf/projects

function echo_info()
{
    local esc_bold="\033[1m"
    local esc_info="\033[32m"
    local esc_reset="\033[0m"
    echo -e "${esc_bold}${esc_info}"$1"${esc_reset}"
}

function echo_warn()
{
    local esc_bold="\033[1m"
    local esc_warn="\033[35m"
    local esc_reset="\033[0m"
    echo -e "${esc_bold}${esc_warn}"$1"${esc_reset}"
}

function echo_error()
{
    local esc_bold="\033[1m"
    local esc_error="\033[31m"
    local esc_reset="\033[0m"
    echo -e "${esc_bold}${esc_error}"$1"${esc_reset}"
}

clean_up()
{
    unset PROGNAME OEROOT_DIR RTK_META_DIR RTK_PROJECT_DIR \
          OLD_OPTIND JOBS THREADS DOWNLOADS CACHES LUNCH_MENU_CHOICES \
          setup_flag setup_h setup_j setup_t \
          setup_builddir setup_download setup_sstate setup_error
}

function usage() {
cat <<EOF
SYNOPSIS
    source $PROGNAME [OPTION]...

DESCRIPTION
    The script will setup the build enviroment for yocto bitbake.

OPTIONS
    -h
        print this help and exit.

    -m machine
        the target machine to be built.

    -d distro
        the target distro to be built.

    -j jobs
        number of jobs for make to spawn during the compilation stage.
    
    -t tasks
        number of BitBake tasks that can be issued in parallel.

    -b path
        non-default path of project build folder.

    -p path
        non-default path of DL_DIR (downloaded source)

    -c path
        non-default path of SSTATE_DIR (shared state Cache)

EXAMPLE
    $ source envsetup.sh -m rtl8730elh-va8 -d ameba-generic -b out

    The script creates the build directory - out, configures it for the
    specified MACHINE:rtl8730elh-va8 and DISTRO:ameba-generic, and prepares
    the calling shell for running bitbake on the build directory.

OTHERS
    The script also add the following functions to your environment:
    - m:       Build all images.
    - mkernel: Build kernel images.
    - mfw:     Build firmware images.
    - lconfig: List available machines and distros of yocto.
    - croot:   Changes directory to the top of the tree.
    - clinux:  Changes directory to the linux of the tree.
    - cyocto:  Changes directory to the yocot of the tree.
    - cgrep:   Greps on all local C/C++ files.
    - mgrep:   Greps on all local Makefile/*.mk/*.make/*.mak files.

EOF
}

function lconfig()
{
    if [ -z "$ROOTDIR" ]; then
        echo "Couldn't locate the top of the tree."
        return
    fi

    ls ${ROOTDIR}/sources/yocto/*/*/conf/machine/*.conf > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "
Realtek Machines: `echo; ls ${ROOTDIR}/sources/yocto/meta-realtek/*/conf/machine/*.conf \
| sed s/\.conf//g | sed -r 's/^.+\///' | xargs -I% echo -e "\t%"`

Realtek Distros: `echo; ls ${ROOTDIR}/sources/yocto/meta-realtek/*/conf/distro/*.conf \
| sed s/\.conf//g | sed -r 's/^.+\///' | xargs -I% echo -e "\t%"`

Poky's Machines: `echo; ls ${ROOTDIR}/sources/yocto/poky/*/conf/machine/*.conf \
| sed s/\.conf//g | sed -r 's/^.+\///' | xargs -I% echo -e "\t%"`

Poky's Distros: `echo; ls ${ROOTDIR}/sources/yocto/poky/meta-poky/conf/distro/*.conf \
| sed s/\.conf//g | sed -r 's/^.+\///' | xargs -I% echo -e "\t%"`
"
    fi
}

function croot()
{
    if [ "$ROOTDIR" ]; then
        \cd ${ROOTDIR}
    else
        echo "Couldn't locate the top of the tree."
    fi
}

function clinux()
{
    if [ "$ROOTDIR" ]; then
        \cd ${ROOTDIR}/sources/kernel/linux-5.4
    else
        echo "Couldn't locate the top of the tree."
    fi
}

function cyocto()
{
    if [ "$ROOTDIR" ]; then
        \cd ${ROOTDIR}/sources/yocto
    else
        echo "Couldn't locate the top of the tree."
    fi
}

function cgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' \) -print0 | xargs -0 grep --color -n "$@"
}

function mgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -path ./out -prune -o -regextype posix-egrep -iregex '(.*\/Makefile|.*\/Makefile\..*|.*\.make|.*\.mak|.*\.mk)' -type f -print0 | xargs -0 grep --color -n "$@"
}

function m()
{
    if [ -z "$BUILDDIR" ]; then
        echo_error "============================================================"
        echo_error "Yocto build enviroment has not been setup."
        echo_error "Please source envsetup.sh to setup build enviroment first."
        echo_error "============================================================"
        return
    fi

    if [ "$1" = "clean" ]; then
        rm -rf $BUILDDIR/tmp
        rm -rf $BUILDDIR/cache
        rm -rf $BUILDDIR/*.log
        echo_info "=> Clean finished"
        return
    fi

    echo_info "=> bitbake ameba-image-core"
    bitbake -f ameba-image-core
    if [ $? -ne 0 ]; then
        echo_error "***************************************"
        echo_error "* Build ameba-image-core error!!!"
        echo_error "***************************************"
        return
    fi

    echo_info "=> bitbake ameba-image-userdata"
    bitbake -f ameba-image-userdata
    if [ $? -ne 0 ]; then
        echo_error "***************************************"
        echo_error "* Build ameba-image-userdata rrror!!!"
        echo_error "***************************************"
        return
    fi
    
    local deploy_dir=${BUILDDIR}/tmp/deploy/images/${TARGET_MACHINE}

    rm -rf ${ROOTDIR}/images
    ln -sf ${deploy_dir} ${ROOTDIR}/images

    cp -f ${deploy_dir}/uImage ${deploy_dir}/kernel.img
    cp -f ${deploy_dir}/ameba-image-core-${TARGET_MACHINE}.ubi ${deploy_dir}/rootfs.img
    cp -f ${deploy_dir}/ameba-image-userdata-${TARGET_MACHINE}.ubi ${deploy_dir}/userdata.img
}

function mkernel()
{
    if [ -z "$BUILDDIR" ]; then
        echo_error "============================================================"
        echo_error "Yocto build enviroment has not been setup."
        echo_error "Please source envsetup.sh to setup build enviroment first."
        echo_error "============================================================"
        return
    fi

    if [ "$1" = "menuconfig" ]; then
        echo_info "=> bitbake virtual/kernel -c menuconfig"
        bitbake virtual/kernel -c menuconfig
        return
    fi

    if [ "$1" = "clean" ]; then
        echo_info "=> bitbake virtual/kernel -c cleanall"
        bitbake virtual/kernel -c cleanall
        return
    fi

    echo_info "=> bitbake virtual/kernel"
    bitbake -fc compile virtual/kernel
    bitbake virtual/kernel
    
    local deploy_dir=${BUILDDIR}/tmp/deploy/images/${TARGET_MACHINE}

    rm -rf ${ROOTDIR}/images
    ln -sf ${deploy_dir} ${ROOTDIR}/images

    cp -f ${deploy_dir}/uImage ${deploy_dir}/kernel.img
}

function mfw()
{
    if [ -z "$BUILDDIR" ]; then
        echo_error "============================================================"
        echo_error "Yocto build enviroment has not been setup."
        echo_error "Please source envsetup.sh to setup build enviroment first."
        echo_error "============================================================"
        return
    fi

    local fw_build=${ROOTDIR}/sources/yocto/meta-realtek/tools/firmware.sh
    local fw_source=${ROOTDIR}/sources/firmware
    local fw_image=$fw_source/amebasmart_gcc_project/project_hp/asdk/image
    local mp_fw_image=$fw_source/amebasmart_gcc_project/project_hp/asdk/image_mp
    local loader_bin_dir=$fw_source/amebasmart_gcc_project/project_hp/asdk/gnu_utility/image_tool_flashloader/amebasmart_acut
    local deploy_dir=${BUILDDIR}/tmp/deploy/images/${TARGET_MACHINE}

    if [ "$1" = "menuconfig" ]; then
        $fw_build -s $fw_source -b menuconfig
        return
    fi

    rm -rf ${ROOTDIR}/images
    mkdir -p ${deploy_dir}
    ln -sf ${deploy_dir} ${ROOTDIR}/images

    local build_target
    if [ -n "$1" ]; then
        build_target=$1
    else
        build_target="wifi"
    fi

    echo_info "=> Build firmware: $fw_build -s $fw_source -b $build_target"
    $fw_build -s $fw_source -b $build_target
    if [ $? -ne 0 ]; then
        echo_error "***************************************"
        echo_error "Build $build_target firmware error!!!"
        echo_error "***************************************"
        return
    fi

    if [ "$1" = "mp" ]; then
        cp -f $mp_fw_image/km4_boot_all.bin ${deploy_dir}/km4_boot_all_mp.bin
        cp -f $mp_fw_image/km0_km4_app_mp.bin ${deploy_dir}/km0_km4_app_mp.bin
    fi
    if [ -z "$1" ]; then
        cp -f $fw_image/km4_boot_all.bin ${deploy_dir}
        cp -f $fw_image/km0_km4_app.bin ${deploy_dir}
    fi
    if [ -f $loader_bin_dir/imgtool_flashloader.bin ]; then
        cp -f $loader_bin_dir/imgtool_flashloader.bin ${deploy_dir}
    fi
}

function mrecovery()
{
    if [ -z "$BUILDDIR" ]; then
        echo_error "============================================================"
        echo_error "Yocto build enviroment has not been setup."
        echo_error "Please source envsetup.sh to setup build enviroment first."
        echo_error "============================================================"
        return
    fi

    echo_info "=> bitbake ameba-image-recovery"
    bitbake -f ameba-image-recovery
    if [ $? -ne 0 ]; then
        echo_error "***************************************"
        echo_error "* Build ameba-image-recovery error!!!"
        echo_error "***************************************"
        return
    fi

    local deploy_dir=${BUILDDIR}/tmp/deploy/images/${TARGET_MACHINE}
    cp ${deploy_dir}/uImage-initramfs-rtl8730elh-recovery.bin ${deploy_dir}/kernel_recovery.img
}

function get_build_config()
{
    if [ ! -f ${TARGET_BUILDDIR}/conf/local.conf ] ; then
        echo_error "The build configuration is not exist!"
        return
    fi

    # get configuration from local.conf
    TARGET_MACHINE="`grep '^MACHINE' ${TARGET_BUILDDIR}/conf/local.conf`"
    TARGET_MACHINE=${TARGET_MACHINE#*\"}
    TARGET_MACHINE=${TARGET_MACHINE%%\"}

    TARGET_DISTRO="`grep '^DISTRO' ${TARGET_BUILDDIR}/conf/local.conf`"
    TARGET_DISTRO=${TARGET_DISTRO#*\"}
    TARGET_DISTRO=${TARGET_DISTRO%%\"}

    TARGET_PACKAGE_CLASSES="`grep '^PACKAGE_CLASSES' ${TARGET_BUILDDIR}/conf/local.conf`"
    TARGET_PACKAGE_CLASSES=${TARGET_PACKAGE_CLASSES#*\"}
    TARGET_PACKAGE_CLASSES=${TARGET_PACKAGE_CLASSES%%\"}
}

function print_config()
{
    echo
    echo "============================================"
    echo "MACHINE=$TARGET_MACHINE"
    echo "DISTRO=$TARGET_DISTRO"
    echo "PACKAGE_CLASSES=$TARGET_PACKAGE_CLASSES"
    echo "HOST_OS=`python -c "import platform; print(platform.platform())"`"
    echo "BUILD_DIR=$TARGET_BUILDDIR"
    echo "============================================"
    echo
}

function prompt_message() {
        cat <<EOF
The Yocto Project has extensive documentation about OE including a
reference manual which can be found at:
    http://yoctoproject.org/documentation

For more information about OpenEmbedded see their website:
    http://www.openembedded.org/

You can now run 'bitbake <target>'

Common targets are:
    ameba-image-core

EOF
}

function print_lunch_menu()
{
    local uname=$(uname)
    echo
    echo "You're building on" $uname
    echo
    echo "Lunch menu... pick a combo:"

    LUNCH_MENU_CHOICES=(`ls ${RTK_META_DIR}/meta-sdk/conf/projects`)

    local i=1
    local choice
    for choice in ${LUNCH_MENU_CHOICES[@]}
    do
        echo "     $i. $choice"
        i=$(($i+1))
    done

    echo
}

function lunch()
{
    local answer

    if [ "$1" ] ; then
        answer=$1
    else
        print_lunch_menu
        echo -n "Which would you like? "
        read answer
    fi

    local selection=

    if [ -z "$answer" ]
    then
        selection=rtl8730elh-va8-generic
    elif (echo -n $answer | grep -q -e "^[0-9][0-9]*$")
    then
        if [ $answer -le ${#LUNCH_MENU_CHOICES[@]} ]
        then
            selection=${LUNCH_MENU_CHOICES[$(($answer-1))]}
        fi
    else
        selection=$answer
    fi

    if [ -z "$selection" ]
    then
        echo
        echo "Invalid lunch selection: $answer"
        return 1
    fi

    local product=$selection
    TARGET_BUILDDIR=$ROOTDIR/build_$product

    if [ -e ${TARGET_BUILDDIR}/conf/local.conf ] ; then
        echo_warn "============================================================"
        echo_warn "build_$product already exist."
        echo_warn "Nothing is changed."
        echo_warn "============================================================"

        setup_oe_build_env $TARGET_BUILDDIR
        get_build_config
        print_config

        clean_up && return
    fi

    setup_oe_build_env $TARGET_BUILDDIR

    # use preconfigured file to overwrite
    cp -f ${RTK_PROJECT_DIR}/${product}/local.conf ${TARGET_BUILDDIR}/conf
    cat >> conf/local.conf <<-EOF

# Parallelism Options
BB_NUMBER_THREADS = "4"
PARALLEL_MAKE = "-j 4"
EOF

    get_build_config
    print_config
    prompt_message
}

function setup_oe_build_env()
{
    local build_dir

    if [ -n "$1" ]; then
        if echo $1 |grep -q ^/;then
            build_dir=$1
        else
            build_dir=${ROOTDIR}/$1
        fi
    else
        build_dir=${ROOTDIR}/build
    fi

    export TEMPLATECONF=${RTK_META_DIR}/meta-sdk/conf
    . ${OEROOT_DIR}/oe-init-build-env $build_dir > /dev/null

    cp ${TEMPLATECONF}/site.conf.sample ${build_dir}/conf/site.conf
}

###############################################################################
# Main entry to setup configuration
###############################################################################
OLD_OPTIND=$OPTIND
while getopts "m:d:j:t:b:p:c:h" setup_flag
do
    case $setup_flag in
        m) setup_machine="$OPTARG";
           ;;
        d) setup_distro="$OPTARG";
           ;;
        j) setup_j="$OPTARG";
           ;;
        t) setup_t="$OPTARG";
           ;;
        b) setup_builddir="$OPTARG";
           ;;
        p) setup_download="$OPTARG";
           ;;
        c) setup_sstate="$OPTARG";
           ;;
        h) setup_h='true';
           ;;
        ?) setup_error='true';
           ;;
    esac
done
OPTIND=$OLD_OPTIND

# check the "-h" and other not supported options
if test $setup_error || test $setup_h; then
    usage && clean_up && return
fi

# check machine
if [ -z "${setup_machine}" ];then
    echo
    echo_info "============================================================"
    echo_info "Machine parameter not specified."
    echo_info "Try 'source envsetup.sh -h' to get information"
    echo
    echo_info "You can also select from bellow menu."
    echo_info "============================================================"

    lunch
    clean_up
    return
fi

TARGET_MACHINE=$setup_machine

# check distro
if [ -n "$setup_distro" ];then
    TARGET_DISTRO=$setup_distro
else
    TARGET_DISTRO="ameba-generic"
fi

# check optional jobs and threads
if echo "$setup_j" | egrep -q "^[0-9]+$"; then
    JOBS=$setup_j
else
    JOBS="4"
fi

if echo "$setup_t" | egrep -q "^[0-9]+$"; then
    THREADS=$setup_t
else
    THREADS="4"
fi

# setup build dir
if [ -n "$setup_builddir" ]; then
    if echo $setup_builddir |grep -q ^/;then
        TARGET_BUILDDIR="${setup_builddir}"
    else
        TARGET_BUILDDIR="`pwd`/${setup_builddir}"
    fi
else
    TARGET_BUILDDIR=${ROOTDIR}/build_${TARGET_MACHINE}_${TARGET_DISTRO}
fi

# setup downloads dir
if [ -n "$setup_download" ]; then
    if echo $setup_download |grep -q ^/;then
        DOWNLOADS="${setup_download}"
    else
        DOWNLOADS="`pwd`/${setup_download}"
    fi
else
    DOWNLOADS=""
fi

# setup shared state dir
if [ -n "$setup_sstate" ]; then
    if echo $setup_sstate |grep -q ^/;then
        CACHES="${setup_sstate}"
    else
        CACHES="`pwd`/${setup_sstate}"
    fi
else
    CACHES=""
fi

# check if build dir was created before
if [ -e ${TARGET_BUILDDIR}/conf/local.conf ] ; then
    echo_warn "============================================================"
    echo_warn "build_${TARGET_MACHINE}_${TARGET_DISTRO} already exist."
    echo_warn "Nothing is changed."
    echo_warn "============================================================"

    rm -fr ${TARGET_BUILDDIR}/conf/bblayers.conf
    setup_oe_build_env $TARGET_BUILDDIR
    get_build_config
    print_config
    clean_up && return
fi

setup_oe_build_env $TARGET_BUILDDIR

# remove comment lines and empty lines
#sed -i -e '/^#.*/d' -e '/^$/d' conf/local.conf

# change local.conf according to environment
if [ ! -z "$TARGET_MACHINE" ]; then
    sed -e "s,MACHINE ??=.*,MACHINE ??= \"$TARGET_MACHINE\",g" -i conf/local.conf
fi

if [ ! -z "$TARGET_DISTRO" ]; then
    sed -e "s,DISTRO ?=.*,DISTRO ?= \"$TARGET_DISTRO\",g" -i conf/local.conf
fi

if [ ! -z "$DOWNLOADS" ]; then
    cat >> conf/local.conf <<-EOF

# Download Options
DL_DIR = "$DOWNLOADS"
EOF
fi

if [ ! -z "$CACHES" ]; then
    cat >> conf/local.conf <<-EOF

# Shared-state Options
SSTATE_DIR = "$CACHES"
EOF
fi

cat >> conf/local.conf <<-EOF

# Parallelism Options
BB_NUMBER_THREADS = "$THREADS"
PARALLEL_MAKE = "-j $JOBS"
EOF

echo "#### Welcome to Realtek Ameba SDK ####"

get_build_config
print_config
prompt_message

clean_up
