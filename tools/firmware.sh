#!/bin/sh
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# Copyright (c) 2023 Realtek, LLC.

function bak_config()
{
    if [ -d ${CONFIG_DIR} ]; then
        if [ ! -e ${CONFIG_DIR}/.config.bak ]; then
            cp -f ${CONFIG_DIR}/.config ${CONFIG_DIR}/.config.bak;
        fi

        if [ ! -e ${CONFIG_DIR}/.config_km0.bak ]; then
            cp -f ${CONFIG_DIR}/.config_km0 ${CONFIG_DIR}/.config_km0.bak;
        fi

        if [ ! -e ${CONFIG_DIR}/.config_km4.bak ]; then
            cp -f ${CONFIG_DIR}/.config_km4 ${CONFIG_DIR}/.config_km4.bak;
        fi

        if [ ! -e ${CONFIG_DIR}/.config_ca32.bak ]; then
            cp -f ${CONFIG_DIR}/.config_ca32 ${CONFIG_DIR}/.config_ca32.bak;
        fi

        if [ ! -e ${CONFIG_DIR}/project_lp/platform_autoconf.h.bak ]; then
            cp -f ${CONFIG_DIR}/project_lp/platform_autoconf.h ${CONFIG_DIR}/project_lp/platform_autoconf.h.bak;
        fi

        if [ ! -e ${CONFIG_DIR}/project_hp/platform_autoconf.h.bak ]; then
            cp -f ${CONFIG_DIR}/project_hp/platform_autoconf.h ${CONFIG_DIR}/project_hp/platform_autoconf.h.bak;
        fi

        if [ ! -e ${CONFIG_DIR}/project_ap/platform_autoconf.h.bak ]; then
            cp -f ${CONFIG_DIR}/project_ap/platform_autoconf.h ${CONFIG_DIR}/project_ap/platform_autoconf.h.bak;
        fi
    fi
}

function enable_linux_config()
{
    echo "Enable linux config"

    rm -f ${GCCPROJECT_DIR}/${PARA_FILENAME}
    if [ -f ${CONFIG_DIR}/.config ]; then
        cd ${GCCPROJECT_DIR}
        ./menuconfig.py -s ${GCCPROJECT_DIR}/${PARA_FILENAME}
        cd -
    fi

    local LINUX_FW_EN_STRING="CONFIG_LINUX_FW_EN=y"
    local MP_NOT_INCLUDE_STRING="CONFIG_MP_INCLUDED=n"
    if ! grep -q "$LINUX_FW_EN_STRING" ${GCCPROJECT_DIR}/${PARA_FILENAME}; then
        echo "$LINUX_FW_EN_STRING" >> ${GCCPROJECT_DIR}/${PARA_FILENAME}
    fi
    if ! grep -q "$MP_NOT_INCLUDE_STRING" ${GCCPROJECT_DIR}/${PARA_FILENAME}; then
        echo "$MP_NOT_INCLUDE_STRING" >> ${GCCPROJECT_DIR}/${PARA_FILENAME}
    fi

    cd ${GCCPROJECT_DIR}
    ./menuconfig.py -f ${GCCPROJECT_DIR}/${PARA_FILENAME}
    rm -f ${GCCPROJECT_DIR}/${PARA_FILENAME}
    cd -
}

function enable_linux_mp_config
{
    echo "Enable linux mp config"

    rm -f ${GCCPROJECT_DIR}/${PARA_FILENAME}
    if [ -f ${CONFIG_DIR}/.config ]; then
        cd ${GCCPROJECT_DIR}
        ./menuconfig.py -s ${GCCPROJECT_DIR}/${PARA_FILENAME}
        cd -
    fi

    local LINUX_FW_EN_STRING="CONFIG_LINUX_FW_EN=y"
    local MP_INCLUDE_STRING="CONFIG_MP_INCLUDED=y"
    local MP_EXPAND_STRING="CONFIG_MP_EXPAND=y"
    if ! grep -q "$LINUX_FW_EN_STRING" ${GCCPROJECT_DIR}/${PARA_FILENAME}; then
        echo "$LINUX_FW_EN_STRING" >> ${GCCPROJECT_DIR}/${PARA_FILENAME}
    fi
    if ! grep -q "$MP_INCLUDE_STRING" ${GCCPROJECT_DIR}/${PARA_FILENAME}; then
        echo "$MP_INCLUDE_STRING" >> ${GCCPROJECT_DIR}/${PARA_FILENAME}
    fi
    if ! grep -q "$MP_EXPAND_STRING" ${GCCPROJECT_DIR}/${PARA_FILENAME}; then
        echo "$MP_EXPAND_STRING" >> ${GCCPROJECT_DIR}/${PARA_FILENAME}
    fi

    cd ${GCCPROJECT_DIR}
    ./menuconfig.py -f ${GCCPROJECT_DIR}/${PARA_FILENAME}
    rm -f ${GCCPROJECT_DIR}/${PARA_FILENAME}
    cd -
}

function reset_config
{
    if [ -d ${CONFIG_DIR} ]; then
        echo "Reset firmware config"
        if [ -e ${CONFIG_DIR}/.config.bak ]; then
            mv -f ${CONFIG_DIR}/.config.bak ${CONFIG_DIR}/.config;
        fi

        if [ -e ${CONFIG_DIR}/.config_km0.bak ]; then
            mv -f ${CONFIG_DIR}/.config_km0.bak ${CONFIG_DIR}/.config_km0;
        fi

        if [ -e ${CONFIG_DIR}/.config_km4.bak ]; then
            mv -f ${CONFIG_DIR}/.config_km4.bak ${CONFIG_DIR}/.config_km4;
        fi

        if [ -e ${CONFIG_DIR}/.config_ca32.bak ]; then
            mv -f ${CONFIG_DIR}/.config_ca32.bak ${CONFIG_DIR}/.config_ca32;
        fi

        if [ -e ${CONFIG_DIR}/project_lp/platform_autoconf.h.bak ]; then
            mv -f ${CONFIG_DIR}/project_lp/platform_autoconf.h.bak ${CONFIG_DIR}/project_lp/platform_autoconf.h;
        fi

        if [ -e ${CONFIG_DIR}/project_hp/platform_autoconf.h.bak ]; then
            mv -f ${CONFIG_DIR}/project_hp/platform_autoconf.h.bak ${CONFIG_DIR}/project_hp/platform_autoconf.h;
        fi

        if [ -e ${CONFIG_DIR}/project_ap/platform_autoconf.h.bak ]; then
            mv -f ${CONFIG_DIR}/project_ap/platform_autoconf.h.bak ${CONFIG_DIR}/project_ap/platform_autoconf.h;
        fi
    fi
}

function build_firmware
{
    bak_config
    enable_linux_config

    cd ${GCCPROJECT_DIR}
    ./build.py
    cd -
}

function build_mp_firmware
{
    bak_config
    enable_linux_mp_config

    cd ${GCCPROJECT_DIR}
    ./build.py
    cd -
}

function make_firmware_menuconfig
{
    bak_config
    cd ${GCCPROJECT_DIR}
    ./menuconfig.py
    cd -
}

function clean_firmware
{
    reset_config

    cd ${GCCPROJECT_DIR}
    ./build.py -c
    cd -
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
PARA_FILENAME=linux_para.conf

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
