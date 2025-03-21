#!/bin/sh

# This script is to install the tools for building yocto sdk.
# It is recommended to run this script on Ubuntu 22.04. If you use other Linux distributions, there may be slight differences in the installed tools.
#       sudo ./install.sh

# Set time-zone and city at first. Users should modify it to the location of their real city.
echo "tzdata tzdata/Areas select Asia" | sudo debconf-set-selections
echo "tzdata tzdata/Zones/Asia select Shanghai" | sudo debconf-set-selections

export DEBIAN_FRONTEND=noninteractive

# Update at first.
apt-get update

# 1. softwares.
apt-get install -y sudo
apt-get install -y make
apt-get install -y make-guile
apt-get install -y build-essential
apt-get install -y chrpath
apt-get install -y diffstat
apt-get install -y g++
apt-get install -y gcc
apt-get install -y gcc-multilib
apt-get install -y dash
apt-get install -y bash
apt-get install -y gawk
apt-get install -y git
apt-get install -y curl
apt-get install -y flex
apt-get install -y bison
apt-get install -y bc
apt-get install -y wget
apt-get install -y zstd
apt-get install -y cmake
apt-get install -y cpio
apt-get install -y gettext
apt-get install -y lz4
apt-get install -y locales
apt-get install -y libncurses-dev
apt-get install -y libncurses5-dev
apt-get install -y libncursesw5-dev
apt-get install -y libelf-dev
apt-get install -y lzop
apt-get install -y libssl-dev
apt-get install -y libsdl1.2-dev
apt-get install -y liblz4-tool
apt-get install -y mtd-utils
apt-get install -y texinfo
apt-get install -y xterm
apt-get install -y python3
apt-get install -y python3-dev
apt-get install -y python3-pip
apt-get install -y python3-pyelftools
apt-get install -y vim
apt-get install -y unzip
apt-get install -y rsync
apt-get install -y libtool
apt-get install -y autoconf
apt-get install -y automake
apt-get install -y m4
apt-get install -y pkg-config
apt-get install -y ninja-build
apt-get install -y dos2unix

# 2. PIP tools. Install them without sudo.
sudo -u $(logname) bash << EOF
pip install pycryptodome
pip install python-mbedtls
pip install sslcrypto
pip install cryptography
pip install pycryptodomex
pip install ecdsa
pip install cmake
EOF

exit 0
