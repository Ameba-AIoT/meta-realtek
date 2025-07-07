#!/bin/sh

if [ -d /sys/block/*/$MDEV ] ;then
    mkdir -p /mnt/storage
    mount /dev/$MDEV /mnt/storage
fi
