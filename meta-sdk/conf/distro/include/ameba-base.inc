require conf/distro/poky.conf

DISTRO = "ameba-base"
DISTRO_NAME = "Realtek Ameba Distro Base"
DISTROOVERRIDES = "ameba"

MAINTAINER = "Realtek Semiconductors <ameba@realtek.com>"

SDK_VENDOR = "-rtksdk"
TARGET_VENDOR = "-rtk"

# Define Init System
INIT_MANAGER = "sysvinit"
SYSVINIT_ENABLED_GETTYS = "S0"

POKY_DEFAULT_DISTRO_FEATURES:remove = "opengl vulkan"

PREFERRED_PROVIDER_virtual/kernel = "linux-ameba"
PREFERRED_PROVIDER_virtual/bootloader = "u-boot-ameba"
