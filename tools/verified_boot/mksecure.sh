#!/bin/bash
#
# Copyright (C) 2022 Realtek
#

PROGNAME="mksecure.sh"

SCRIPT_PATH=`dirname $0`

ELF2BIN=$SCRIPT_PATH/elf2bin
AVBTOOL=$SCRIPT_PATH/avbtool

OUTPUT_DIR=images
INPUT_DIR=images

ROLLBACK_INDEX=1
VBMETA_RSA_ALGO=SHA512_RSA2048
VBMETA_HASH_ALGO=sha512
VBMETA_HASH_BLOCK_SIZE=4096

VBMETA_PRIV_KEY=vbmeta.priv.key
VBMETA_PUB_KEY=vbmeta.pub.key

SLASH_CHAR="/"

trim_last_slash() {
    echo "${1%%/}"
}

function usage() {
cat <<EOF
SYNOPSIS
    $PROGNAME [OPTION]

OPTIONS
    -h --help
        print this help and exit.

    --key_dir
        set the secure key directory.

    --output_dir
        set the directory to ouput secure images.

    --input_dir
        if image-name is not specified, use default images in this directory to make secure images.

    --use_dtb_size
        if use_dtb_size is set, mksecure.sh will parse the size of dts, kernel, rootfs from setting in dtb which is selected.

    --boot_image
        set linux boot image path.

    --dtb_image
        set dtb image path.

    --dtb_part_size
        set dtb partition size.

    --kernel_image
        set kernel image path.

    --kernel_part_size
        set kernel partition size.

    --root_image
        set rootfs image path.

    --root_part_size
        set rootfs partition size.

    --km4_boot
        set km4 boot image path.

    --km4_app
        set km4 app image path.

    --imgtool_flashloader
        set imagetool flashloader image path

    --rollback_index
        set rollback index

    --recovery_dtb_image
        set recovery dtb image path.

    --recovery_dtb_part_size
        set recovery dtb partition size.

    --recovery_kernel_image
        set recovery kernel image path.

    --recovery_kernel_part_size
        set recovery kernel partition size.
EOF
}

SHORTOPTS="hk:o:i:s:"
LONGOPTS="help,key_dir:,output_dir:,input_dir:,use_dtb_size:,boot_image:,dtb_image:,dtb_part_size:,kernel_image:,kernel_part_size:,root_image:,root_part_size:,km4_boot:,km4_app:,imgtool_flashloader:,rollback_index:,recovery_dtb_image:,recovery_dtb_part_size:,recovery_kernel_image:,recovery_kernel_part_size:"

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
        -k|--key_dir)
            #echo "Option --key_dir=$2";
            KEY_DIR=$2
            shift 2
            ;;
        -o|--output_dir)
            #echo "Option --output_dir=$2";
            OUTPUT_DIR=$2
            first_letter="${OUTPUT_DIR:0:1}"
            if [ "$first_letter" = "/" ]; then
                # The given path is absolute path
                OUTPUT_DIR=$2
            else
                # The given path is relative path
                OUTPUT_DIR=$(pwd)$SLASH_CHAR$2
            fi
            echo Secure images will output to $OUTPUT_DIR
            shift 2
            ;;
        -i|--input_dir)
            #echo "Option --input_dir=$2";
            INPUT_DIR=$(trim_last_slash "$2")
            shift 2
            ;;
        -s|--use_dtb_size)
            #echo "Option --use_dtb_size=$2";
            USE_DTB_SIZE=$2
            shift 2
            ;;
        --boot_image)
            #echo "Option --boot_image=$2";
            BOOT_IMAGE=$2
            shift 2
            ;;
        --dtb_image)
            #echo "Option --dtb_image=$2";
            DTB_IMAGE=$2
            shift 2
            ;;
        --dtb_part_size)
            #echo "Option --dtb_part_size=$2";
            DTB_PARTITION_SIZE=$2
            shift 2
            ;;
        --kernel_image)
            #echo "Option --kernel_image=$2";
            KERNEL_IMAGE=$2
            shift 2
            ;;
        --kernel_part_size)
            #echo "Option --kernel_part_size=$2";
            KERNEL_PARTITION_SIZE=$2
            shift 2
            ;;
        --root_image)
            #echo "Option --root_image=$2";
            ROOTFS_IMAGE=$2
            shift 2
            ;;
        --root_part_size)
            #echo "Option --root_part_size=$2";
            ROOTFS_PARTITION_SIZE=$2
            shift 2
            ;;
        --km4_boot)
            #echo "Option --km4_boot=$2";
            KM4_BOOT_IMAGE=$2
            shift 2
            ;;
        --km4_app)
            #echo "Option --km4_app=$2";
            KM4_APP_IMAGE=$2
            shift 2
            ;;
        --imgtool_flashloader)
            #echo "Option --imgtool_flashloader=$2";
            IMGTOOL_FLASHLODER_IMG=$2
            shift 2
            ;;
        --rollback_index)
            #echo "Option --rollback_index=$2";
            ROLLBACK_INDEX=$2
            shift 2
            ;;
        --recovery_dtb_image)
            #echo "Option --recovery_dtb_image=$2";
            RECOVERY_DTB_IMAGE=$2
            shift 2
            ;;
        --recovery_dtb_part_size)
            #echo "Option --recovery_dtb_part_size=$2";
            RECOVERY_DTB_PARTITION_SIZE=$2
            shift 2
            ;;
        --recovery_kernel_image)
            #echo "Option --recovery_kernel_image=$2";
            RECOVERY_KERNEL_IMAGE=$2
            shift 2
            ;;
        --recovery_kernel_part_size)
            #echo "Option --recovery_kernel_part_size=$2";
            RECOVERY_KERNEL_PARTITION_SIZE=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error!"
            exit 1
            ;;
    esac
done

#echo remaining parameters=[$@]
#echo \$1=[$1]
#echo \$2=[$2]

if [ -z "$DTB_IMAGE" ]; then
    echo "Warning: the path+name of dtb image must be specified."
    exit 1
fi

if [ -z "$BOOT_IMAGE" ]; then
    DEFAULT_BOOT_IMAGE="boot.img"
    BOOT_IMAGE=$INPUT_DIR$SLASH_CHAR$DEFAULT_BOOT_IMAGE
    #echo "Use kernel image: $BOOT_IMAGE"
fi

if [ -z "$KERNEL_IMAGE" ]; then
    DEFAULT_KERNEL_IMAGE="uImage"
    KERNEL_IMAGE=$INPUT_DIR$SLASH_CHAR$DEFAULT_KERNEL_IMAGE
    #echo "Use kernel image: $KERNEL_IMAGE"
fi

if [ -z "$ROOTFS_IMAGE" ]; then
    cd $INPUT_DIR
    DEFAULT_ROOTFS_IMAGE=$(grep -rl --include="*.rootfs.squashfs" .)
    ROOTFS_IMAGE=$INPUT_DIR$SLASH_CHAR$DEFAULT_ROOTFS_IMAGE
    cd -
    #echo "Use rootfs image: $ROOTFS_IMAGE"
fi

if [ -z "$KM4_BOOT_IMAGE" ]; then
    DEFAULT_KM4_BOOT_IMAGE="km4_boot_all.bin"
    KM4_BOOT_IMAGE=$INPUT_DIR$SLASH_CHAR$DEFAULT_KM4_BOOT_IMAGE
    if [ ! -f $KM4_BOOT_IMAGE ]; then
        echo "File '$KM4_BOOT_IMAGE' does not exist!! Please mfw first."
        exit 0
    fi
    #echo "Use km4 boot image: $KM4_BOOT_IMAGE"
fi

if [ -z "$KM4_APP_IMAGE" ]; then
    DEFAULT_KM4_APP_IMAGE="km0_km4_app.bin"
    KM4_APP_IMAGE=$INPUT_DIR$SLASH_CHAR$DEFAULT_KM4_APP_IMAGE
    if [ ! -f $KM4_APP_IMAGE ]; then
        echo "File '$KM4_APP_IMAGE' does not exist!! Please mfw first."
        exit 0
    fi
    #echo "Use km4 app image: $KM4_APP_IMAGE"
fi

if [ -z "$IMGTOOL_FLASHLODER_IMG" ]; then
    DEFAULT_IMGTOOL_FLASHLODER_IMG="imgtool_flashloader.bin"
    IMGTOOL_FLASHLODER_IMG=$INPUT_DIR$SLASH_CHAR$DEFAULT_IMGTOOL_FLASHLODER_IMG
    #echo "Use imgtool_flashloader: $IMGTOOL_FLASHLODER_IMG"
fi

# recovery kernel image
if [ ! -z "$RECOVERY_DTB_IMAGE" ]; then
    if [ -z "$RECOVERY_KERNEL_IMAGE" ]; then
        DEFAULT_RECOVERY_KERNEL_IMAGE="uImage-initramfs-rtl8730elh-recovery.bin"
        RECOVERY_KERNEL_IMAGE=$(dirname $RECOVERY_DTB_IMAGE)
        RECOVERY_KERNEL_IMAGE+=$SLASH_CHAR$DEFAULT_RECOVERY_KERNEL_IMAGE
        #echo "Use recovery kernel image: $RECOVERY_KERNEL_IMAGE"
    fi
fi

if [ $USE_DTB_SIZE == "1" ]; then
    mkdir -p $OUTPUT_DIR
    mkdir -p $OUTPUT_DIR/secure-auxiliary
    # normal dtb
    fdtdump -sd $DTB_IMAGE > $OUTPUT_DIR/secure-auxiliary/parse.dts 2>/dev/null
    DTB_PARTITION_SIZE=$(python3 $SCRIPT_PATH/partition_parser $OUTPUT_DIR/secure-auxiliary/parse.dts dtb)
    KERNEL_PARTITION_SIZE=$(python3 $SCRIPT_PATH/partition_parser $OUTPUT_DIR/secure-auxiliary/parse.dts kernel)
    ROOTFS_PARTITION_SIZE=$(python3 $SCRIPT_PATH/partition_parser $OUTPUT_DIR/secure-auxiliary/parse.dts rootfs)
    # recovery dtb
    if [ ! -z "$RECOVERY_DTB_IMAGE" ]; then
        fdtdump -sd $RECOVERY_DTB_IMAGE > $OUTPUT_DIR/secure-auxiliary/parse_recovery.dts 2>/dev/null
        RECOVERY_DTB_PARTITION_SIZE=$(python3 $SCRIPT_PATH/partition_parser $OUTPUT_DIR/secure-auxiliary/parse_recovery.dts dtb)
        RECOVERY_KERNEL_PARTITION_SIZE=$(python3 $SCRIPT_PATH/partition_parser $OUTPUT_DIR/secure-auxiliary/parse_recovery.dts kernel)
    fi
fi

function echo_info()
{
    local esc_bold="\033[1m"
    local esc_info="\033[32m"
    local esc_reset="\033[0m"
    echo -e "${esc_bold}${esc_info}"$1"${esc_reset}"
}

function echo_error()
{
    local esc_bold="\033[1m"
    local esc_error="\033[31m"
    local esc_reset="\033[0m"
    echo -e "${esc_bold}${esc_error}"$1"${esc_reset}"
}

if [ -z "$KEY_DIR" ] || [ -z "$BOOT_IMAGE" ] || \
   [ -z "$DTB_IMAGE" ] || [ -z "$DTB_PARTITION_SIZE" ] || \
   [ -z "$KERNEL_IMAGE" ] || [ -z "$KERNEL_PARTITION_SIZE" ] || \
   [ -z "$ROOTFS_IMAGE" ] || [ -z "$ROOTFS_PARTITION_SIZE" ] || \
   [ -z "$KM4_BOOT_IMAGE" ] || [ -z "$KM4_APP_IMAGE" ];then
    echo_error "Invalid command options."
    usage
    exit 1
fi

if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p $OUTPUT_DIR
fi

if [ ! -e $OUTPUT_DIR/secure-auxiliary ] ; then
    mkdir -p $OUTPUT_DIR/secure-auxiliary
fi

function make_vbmeta_hash_footer()
{
    cp $1 $OUTPUT_DIR/${3}_origin.img
    python3 $AVBTOOL add_hash_footer \
        --image $OUTPUT_DIR/${3}_origin.img \
        --partition_size $2 \
        --partition_name $3 \
        --hash_algorithm $VBMETA_HASH_ALGO \
        --key $KEY_DIR/$VBMETA_PRIV_KEY \
        --rollback_index ${ROLLBACK_INDEX} \
        --output_vbmeta_image $OUTPUT_DIR/secure-auxiliary/${3}_desc.img \
        --do_not_use_ab \
        --public_key_metadata $KEY_DIR/$VBMETA_PUB_KEY \
        --algorithm $VBMETA_RSA_ALGO \
        --do_not_append_vbmeta_image

    cp $OUTPUT_DIR/${3}_origin.img $OUTPUT_DIR/${3}.img
    rm -fr $OUTPUT_DIR/${3}_origin.img
    echo_info "=> Install: $OUTPUT_DIR/${3}.img"
}

function make_vbmeta_hashtree_footer()
{
    cp $1 $OUTPUT_DIR/rootfs_squashfs.img
    python3 $AVBTOOL add_hashtree_footer \
        --image $OUTPUT_DIR/rootfs_squashfs.img \
        --partition_size $2 \
        --partition_name $3 \
        --hash_algorithm $VBMETA_HASH_ALGO \
        --block_size $VBMETA_HASH_BLOCK_SIZE \
        --key $KEY_DIR/$VBMETA_PRIV_KEY \
        --rollback_index ${ROLLBACK_INDEX} \
        --output_vbmeta_image $OUTPUT_DIR/secure-auxiliary/${3}_desc.img \
        --public_key_metadata $KEY_DIR/$VBMETA_PUB_KEY \
        --algorithm $VBMETA_RSA_ALGO \
        --do_not_append_vbmeta_image \
        --setup_as_rootfs_from_kernel \
        --do_not_generate_fec \
        --do_not_use_ab

    touch $OUTPUT_DIR/ubinize.cfg
    echo \[ubifs\] > $OUTPUT_DIR/ubinize.cfg
    echo mode=ubi >> $OUTPUT_DIR/ubinize.cfg
    echo image=$OUTPUT_DIR/rootfs_squashfs.img >> $OUTPUT_DIR/ubinize.cfg
    echo vol_id=0 >> $OUTPUT_DIR/ubinize.cfg
    echo vol_type=dynamic >> $OUTPUT_DIR/ubinize.cfg
    echo vol_name=$3 >> $OUTPUT_DIR/ubinize.cfg
    echo vol_flags=autoresize >> $OUTPUT_DIR/ubinize.cfg

    echo "ubinize -m 2048 -p 131072 -O 2048 -o $OUTPUT_DIR/rootfs.img $OUTPUT_DIR/ubinize.cfg"
    ubinize -m 2048 -p 131072 -O 2048 -o $OUTPUT_DIR/rootfs.img $OUTPUT_DIR/ubinize.cfg
    rm -fr $OUTPUT_DIR/rootfs_squashfs.img

    echo_info "=> Install: $OUTPUT_DIR/rootfs.img"
}

function make_vbmeta_image()
{
    python3 $AVBTOOL make_vbmeta_image \
        --output $OUTPUT_DIR/vbmeta.img \
        --key $KEY_DIR/$VBMETA_PRIV_KEY \
        --public_key_metadata $KEY_DIR/$VBMETA_PUB_KEY \
        --rollback_index ${ROLLBACK_INDEX} \
        --generate_dm_verity_cmdline_from_hashtree ${OUTPUT_DIR}/secure-auxiliary/rootfs_desc.img \
        --chain_partition kernel:${ROLLBACK_INDEX}:$OUTPUT_DIR/secure-auxiliary/kernel_desc.img \
        --include_descriptors_from_image $OUTPUT_DIR/secure-auxiliary/kernel_desc.img \
        --include_descriptors_from_image $OUTPUT_DIR/secure-auxiliary/dtb_desc.img \
        --include_descriptors_from_image $OUTPUT_DIR/secure-auxiliary/rootfs_desc.img \
        --algorithm $VBMETA_RSA_ALGO

    echo_info "=> Install: $OUTPUT_DIR/vbmeta.img"
}

function make_recovery_vbmeta_image()
{
    python3 $AVBTOOL make_vbmeta_image \
        --output $OUTPUT_DIR/recovery_vbmeta.img \
        --key $KEY_DIR/$VBMETA_PRIV_KEY \
        --public_key_metadata $KEY_DIR/$VBMETA_PUB_KEY \
        --rollback_index ${ROLLBACK_INDEX} \
        --chain_partition kernel:${ROLLBACK_INDEX}:$OUTPUT_DIR/secure-auxiliary/kernel_recovery_desc.img \
        --include_descriptors_from_image $OUTPUT_DIR/secure-auxiliary/kernel_recovery_desc.img \
        --include_descriptors_from_image $OUTPUT_DIR/secure-auxiliary/dtb_recovery_desc.img \
        --algorithm $VBMETA_RSA_ALGO

    echo_info "=> Install: $OUTPUT_DIR/recovery_vbmeta.img"
}

function make_secure_linux()
{
    make_vbmeta_hash_footer $DTB_IMAGE $DTB_PARTITION_SIZE dtb
    make_vbmeta_hash_footer $KERNEL_IMAGE $KERNEL_PARTITION_SIZE kernel
    make_vbmeta_hashtree_footer $ROOTFS_IMAGE $ROOTFS_PARTITION_SIZE rootfs
    make_vbmeta_image
}

function make_secure_recovery()
{
    make_vbmeta_hash_footer $RECOVERY_DTB_IMAGE $RECOVERY_DTB_PARTITION_SIZE dtb_recovery
    make_vbmeta_hash_footer $RECOVERY_KERNEL_IMAGE $RECOVERY_KERNEL_PARTITION_SIZE kernel_recovery
    make_recovery_vbmeta_image
}

function make_secure_firmware()
{
    # 1. make secure km4 boot image

    # cut the original manifest head to remake it
    tail -c +4097 $KM4_BOOT_IMAGE > $OUTPUT_DIR/secure-auxiliary/km4_boot_all.bin

    $ELF2BIN manifest \
        $KEY_DIR/manifest.json \
        $KEY_DIR/manifest.json \
        $OUTPUT_DIR/secure-auxiliary/km4_boot_all.bin \
        $OUTPUT_DIR/secure-auxiliary/manifest_km4boot.bin \
        boot

    cat $OUTPUT_DIR/secure-auxiliary/manifest_km4boot.bin \
        $OUTPUT_DIR/secure-auxiliary/km4_boot_all.bin \
        > $OUTPUT_DIR/km4_boot_all.bin

    echo_info "=> Install: $OUTPUT_DIR/km4_boot_all.bin"

    # 2. make secure km4 app image

    # cut the original manifest and cert head to remake it
    tail -c +8193 $KM4_APP_IMAGE > $OUTPUT_DIR/secure-auxiliary/km0_km4_app.bin

    $ELF2BIN manifest \
        $KEY_DIR/manifest.json \
        $KEY_DIR/manifest.json \
        $OUTPUT_DIR/secure-auxiliary/km0_km4_app.bin \
        $OUTPUT_DIR/secure-auxiliary/manifest_km4app.bin \
        app

    $ELF2BIN cert \
        $KEY_DIR/manifest.json \
        $KEY_DIR/manifest.json \
        $OUTPUT_DIR/secure-auxiliary/cert.bin \
        0 app \
        1 vbmeta \
        2 app

    cat $OUTPUT_DIR/secure-auxiliary/cert.bin \
        $OUTPUT_DIR/secure-auxiliary/manifest_km4app.bin \
        $OUTPUT_DIR/secure-auxiliary/km0_km4_app.bin \
        > $OUTPUT_DIR/km0_km4_app.bin

    echo_info "=> Install: $OUTPUT_DIR/km0_km4_app.bin"

    # 3. make secure linux boot image

    # cut the original manifest head to remake it
    tail -c +4097 $BOOT_IMAGE > $OUTPUT_DIR/secure-auxiliary/boot.img

    $ELF2BIN manifest \
        $KEY_DIR/manifest.json \
        $KEY_DIR/manifest.json \
        $OUTPUT_DIR/secure-auxiliary/boot.img \
        $OUTPUT_DIR/secure-auxiliary/manifest_boot.bin \
        app

    cat $OUTPUT_DIR/secure-auxiliary/manifest_boot.bin \
        $OUTPUT_DIR/secure-auxiliary/boot.img \
        > $OUTPUT_DIR/boot.img

    echo_info "=> Install: $OUTPUT_DIR/boot.img"

    # 3. make secure imagetool flashloader
    if [ ! -f $IMGTOOL_FLASHLODER_IMG ]; then
        echo_error "No imgtool_flashloader.bin provided"
        exit 1
    fi
    head -zc -4096 $IMGTOOL_FLASHLODER_IMG > $OUTPUT_DIR/secure-auxiliary/ram_1_prepend.bin

    $ELF2BIN manifest \
        $KEY_DIR/manifest.json \
        $KEY_DIR/manifest.json \
        $OUTPUT_DIR/secure-auxiliary/ram_1_prepend.bin \
        $OUTPUT_DIR/secure-auxiliary/manifest_loader.bin \
        boot

    cat $OUTPUT_DIR/secure-auxiliary/ram_1_prepend.bin $OUTPUT_DIR/secure-auxiliary/manifest_loader.bin > $OUTPUT_DIR/floader_rtl8730e.bin

    echo_info "=> Install: $OUTPUT_DIR/floader_rtl8730e.bin"
}

echo
echo "Start to make secure images."
make_secure_firmware
make_secure_linux

if [ ! -z "$RECOVERY_DTB_IMAGE" ] && [ ! -z "$RECOVERY_DTB_PARTITION_SIZE" ] && \
   [ ! -z "$RECOVERY_KERNEL_IMAGE" ] && [ ! -z "$RECOVERY_KERNEL_PARTITION_SIZE" ];then
echo "Start to make recovery secure images."
make_secure_recovery
fi
