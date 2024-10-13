#!/bin/bash
#
# Copyright (C) 2022 Realtek
#

PROGNAME="release.sh"

SCRIPT_PATH=`dirname $0`

REPO_SYNC_JOBS=10

SDK_DIR=sdk-$(date +%Y%m%d.%H%M%S)
SDK_CHECK_DIR=${SDK_DIR}-check

function usage() {
cat <<EOF
SYNOPSIS
    $PROGNAME [OPTION]

OPTIONS
    -h --help
        print this help and exit.

    -s, --source
        set the source directory.

    -u, --url
        set the url to download sdk source.

    -m, --manifest
        set the manifest for repo to download.

    -p, --patch
        set the patches directory.

    -o, --output
        set the directory to ouput sdk.

EOF
}

SHORTOPTS="hs:u:m:p:o:"
LONGOPTS="help,source:,url:,manifest:,patch:,output:"

ARGS=`getopt -o $SHORTOPTS --long $LONGOPTS -n "$0" -- "$@"`
if [ $? != 0 ]; then
    usage
    exit 1
fi

#echo ARGS=[$ARGS]
eval set -- "${ARGS}"

while true
do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -s|--source)
            #echo "Option --source=$2";
            SOURCE_DIR=$2
            shift 2
            ;;
        -u|--url)
            #echo "Option --url=$2";
            REPO_URL=$2
            shift 2
            ;;
        -m|--manifest)
            #echo "Option --manifest=$2";
            REPO_MANIFEST=$2
            shift 2
            ;;
        -p|--patch)
            #echo "Option --patch=$2";
            PATCH_DIR=$2
            shift 2
            ;;
        -o|--output)
            #echo "Option --output=$2";
            SDK_DIR=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "parse error!"
            exit 1
            ;;
    esac
done

#echo remaining parameters=[$@]
#echo \$1=[$1]
#echo \$2=[$2]

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

function remove_git_dir() {
    find $1 -name ".git" | xargs rm -rf
    find $1 -name ".repo" | xargs rm -rf
}

function download_source()
{
    mkdir -p $1
    cd $1

    repo init -u $REPO_URL -m $REPO_MANIFEST
    repo sync -j $REPO_SYNC_JOBS

    cd -
}

function create_sdk() {
    echo_info "=> copy sdk: $SOURCE_DIR -> $SDK_DIR"
    cp -rf $SOURCE_DIR $SDK_DIR

    echo_info "==> copy cfg80211_fullmac to sdk kernel ..."
    rm -rf $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/net/wireless/cfg80211_fullmac
    cp -frR $SDK_DIR/sources/firmware/component/wifi/cfg80211_fullmac $SDK_DIR/sources/kernel/linux-5.4/drivers/rtkdrivers/net/wireless/

    echo_info "=> remove firmware: $SDK_DIR/sources/firmware"
    rm -rf $SDK_DIR/sources/firmware

    tar -xzf ${SCRIPT_PATH}/${FW_SDK_VERSION}.tgz
    mv ${FW_SDK_VERSION} $SDK_DIR/sources/firmware

    echo_info "=> remove .git and .repo from $1"
    remove_git_dir $SDK_DIR
}

function patch_sdk() {
    if [ -z "$PATCH_DIR" ]; then
        return
    fi

    echo_info "=> start to patch sdk: $SDK_DIR"

    local suffix
    for patch in $(ls $PATCH_DIR)
    do
        suffix=${patch##*.}

        if [ "$suffix" = "sh" ]; then
            echo_info "- execute: $patch ..."
            $PATCH_DIR/$patch $SDK_DIR
        elif [ "$suffix" = "patch" ]; then
            cd $SDK_DIR
            patch -p0  < $PATCH_DIR/$patch
            cd -
            echo
        else
            echo_error "unknow patch type: $patch"
        fi
    done

}

function build_sdk() {
    echo_info "=> build verify sdk: $SDK_CHECK_DIR"

    cd $SDK_CHECK_DIR
    source envsetup.sh -m rtl8730elh-va7 -d ameba-generic
    m
    cd -
}

if [ -z "$SOURCE_DIR" ] && [ -z "$REPO_URL" ]; then
    echo_error "Error: sdk source directory not specfied."
    echo
    usage
    exit 1
fi

if [ -z "$PATCH_DIR" ]; then
    echo_warn "Warning: patch directory not specfied."
fi

echo
echo "===================================="
echo "PWD=$(pwd)"
echo "SOURCE=$SOURCE_DIR"
echo "REPO_URL=$REPO_URL"
echo "REPO_MANIFEST=$REPO_MANIFEST"
echo "PATCH=$PATCH_DIR"
echo "SDK=$SDK_DIR"
echo "===================================="
echo

if [ -z "$SOURCE_DIR" ];then
    SOURCE_DIR=pgos
    echo_info "=> download sdk source to $SOURCE_DIR"
    download_source $SOURCE_DIR
fi

create_sdk
patch_sdk

echo_info "=> copy verify sdk: $SDK_DIR -> $SDK_CHECK_DIR"
cp -rf $SDK_DIR $SDK_CHECK_DIR

build_sdk
