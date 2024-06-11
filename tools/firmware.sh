#!/bin/sh
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# Copyright (c) 2023 Realtek, LLC.

function bak_config()
{
    if [ ! -e ${CONFIG_DIR}/.config.bak ]; then \
        cp -f ${CONFIG_DIR}/.config ${CONFIG_DIR}/.config.bak; \
    fi

    if [ ! -e ${CONFIG_DIR}/.config_lp.bak ]; then \
        cp -f ${CONFIG_DIR}/.config_lp ${CONFIG_DIR}/.config_lp.bak; \
    fi

    if [ ! -e ${CONFIG_DIR}/.config_hp.bak ]; then \
        cp -f ${CONFIG_DIR}/.config_hp ${CONFIG_DIR}/.config_hp.bak; \
    fi

    if [ ! -e ${GCCPROJECT_DIR}/project_lp/inc/platform_autoconf.h.bak ]; then \
        cp -f ${GCCPROJECT_DIR}/project_lp/inc/platform_autoconf.h ${GCCPROJECT_DIR}/project_lp/inc/platform_autoconf.h.bak; \
    fi

    if [ ! -e ${GCCPROJECT_DIR}/project_hp/inc/platform_autoconf.h.bak ]; then \
        cp -f ${GCCPROJECT_DIR}/project_hp/inc/platform_autoconf.h ${GCCPROJECT_DIR}/project_hp/inc/platform_autoconf.h.bak; \
    fi
}


function enable_linux_config()
{
    echo "Enable linux config"

    sed -i 's/^# CONFIG_LINUX_FW_EN is not set/CONFIG_LINUX_FW_EN=y/g' ${CONFIG_DIR}/.config
    sed -i 's/^# CONFIG_LINUX_FW_EN is not set/CONFIG_LINUX_FW_EN=y/g' ${CONFIG_DIR}/.config_lp
    sed -i 's/^# CONFIG_LINUX_FW_EN is not set/CONFIG_LINUX_FW_EN=y/g' ${CONFIG_DIR}/.config_hp

    sed -i 's/^#undef  CONFIG_LINUX_FW_EN/#define CONFIG_LINUX_FW_EN 1/g' ${GCCPROJECT_DIR}/project_lp/inc/platform_autoconf.h
    sed -i 's/^#undef  CONFIG_LINUX_FW_EN/#define CONFIG_LINUX_FW_EN 1/g' ${GCCPROJECT_DIR}/project_hp/inc/platform_autoconf.h

}

function enable_mp_config
{
    echo "Enable firmware MP config"

    sed -i 's/^# CONFIG_MP_INCLUDED is not set/CONFIG_MP_INCLUDED=y/g' ${CONFIG_DIR}/.config
    sed -i 's/^# CONFIG_MP_INCLUDED is not set/CONFIG_MP_INCLUDED=y/g' ${CONFIG_DIR}/.config_lp
    sed -i 's/^# CONFIG_MP_INCLUDED is not set/CONFIG_MP_INCLUDED=y/g' ${CONFIG_DIR}/.config_hp

    sed -i 's/^#undef  CONFIG_MP_INCLUDED/#define CONFIG_MP_INCLUDED 1/g' ${GCCPROJECT_DIR}/project_lp/inc/platform_autoconf.h
    sed -i 's/^#undef  CONFIG_MP_INCLUDED/#define CONFIG_MP_INCLUDED 1/g' ${GCCPROJECT_DIR}/project_hp/inc/platform_autoconf.h
}

function disable_mp_config
{
    echo "Disable firmware MP config"

    sed -i 's/^CONFIG_MP_INCLUDED=y/# CONFIG_MP_INCLUDED is not set/g' ${CONFIG_DIR}/.config
    sed -i 's/^CONFIG_MP_INCLUDED=y/# CONFIG_MP_INCLUDED is not set/g' ${CONFIG_DIR}/.config_lp
    sed -i 's/^CONFIG_MP_INCLUDED=y/# CONFIG_MP_INCLUDED is not set/g' ${CONFIG_DIR}/.config_hp

    sed -i 's/^#define CONFIG_MP_INCLUDED 1/#undef  CONFIG_MP_INCLUDED/g' ${GCCPROJECT_DIR}/project_lp/inc/platform_autoconf.h
    sed -i 's/^#define CONFIG_MP_INCLUDED 1/#undef  CONFIG_MP_INCLUDED/g' ${GCCPROJECT_DIR}/project_hp/inc/platform_autoconf.h
}

function reset_config
{
    echo "Reset firmware config"
    if [ -e ${CONFIG_DIR}/.config.bak ]; then \
        mv -f ${CONFIG_DIR}/.config.bak ${CONFIG_DIR}/.config; \
    fi

    if [ -e ${CONFIG_DIR}/.config_lp.bak ]; then \
        mv -f ${CONFIG_DIR}/.config_lp.bak ${CONFIG_DIR}/.config_lp; \
    fi

    if [ -e ${CONFIG_DIR}/.config_hp.bak ]; then \
        mv -f ${CONFIG_DIR}/.config_hp.bak ${CONFIG_DIR}/.config_hp; \
    fi

    if [ -e ${CONFIG_DIR}/.config_hp.bak ]; then \
        mv -f ${CONFIG_DIR}/.config_hp.bak ${CONFIG_DIR}/.config_hp; \
    fi

    if [ -e ${GCCPROJECT_DIR}/project_lp/inc/platform_autoconf.h.bak ]; then \
        mv -f ${GCCPROJECT_DIR}/project_lp/inc/platform_autoconf.h.bak ${GCCPROJECT_DIR}/project_lp/inc/platform_autoconf.h; \
    fi

    if [ -e ${GCCPROJECT_DIR}/project_hp/inc/platform_autoconf.h.bak ]; then \
        mv -f ${GCCPROJECT_DIR}/project_hp/inc/platform_autoconf.h.bak ${GCCPROJECT_DIR}/project_hp/inc/platform_autoconf.h; \
    fi
}

function build_firmware
{
    bak_config
    enable_linux_config
    disable_mp_config

    make -C ${GCCPROJECT_DIR} -s all
}

function build_mp_firmware
{
    bak_config
    enable_linux_config
    enable_mp_config

    make -C ${GCCPROJECT_DIR} -s all
}

function make_firmware_menuconfig
{
    bak_config
    make -C ${GCCPROJECT_DIR} -s menuconfig
}

function clean_firmware
{
    reset_config

    make -C ${GCCPROJECT_DIR} -s clean
}

usage() {
    echo "Usage: ./firmware.sh -s <source> -b <target>"
    echo "    Optional parameters:
    * [-s source]:  source directory
    * [-b target]:  target to build.
    * [-h]:         help
"
}

FW_SRC_DIR="firmware"
BUILD_TARGET="wifi"

while getopts "s:b:h" setup_flag
do
    case $setup_flag in
        s) FW_SRC_DIR="$OPTARG";
           ;;
        b) BUILD_TARGET="$OPTARG";
           ;;
        h) setup_h='true';
           ;;
        ?) setup_error='true';
           ;;
    esac
done

# check the "-h" and other not supported options
if test $setup_error || test $setup_h; then
    usage && exit 1
fi

if [ ! -d ${FW_SRC_DIR} ]; then \
    echo "Invalid directory: $FW_SRC_DIR"
    exit 1
fi

GCCPROJECT_DIR=${FW_SRC_DIR}/amebasmart_gcc_project
CONFIG_DIR=${GCCPROJECT_DIR}/menuconfig


if [ "$BUILD_TARGET" = "wifi" ]; then
    build_firmware

elif [ "$BUILD_TARGET" = "mp" ]; then
    build_mp_firmware

elif [ "$BUILD_TARGET" = "menuconfig" ]; then
    make_firmware_menuconfig

elif [ "$BUILD_TARGET" = "clean" ]; then
    clean_firmware

else
    echo -e "Invalid build target: $BUILD_TARGET"
fi
