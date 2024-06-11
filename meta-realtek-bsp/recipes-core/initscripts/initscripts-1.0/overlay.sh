#!/bin/sh

for dir in overlay workdir merged
do
if [ ! -e /mnt/$dir ] ; then
mkdir /mnt/$dir
fi
done
mount -t overlay overlay -o lowerdir=/,upperdir=/mnt/overlay,workdir=/mnt/workdir /mnt/merged

echo "mounting proc ..."
mount -t proc proc /mnt/merged/proc
mount -t sysfs sysfs /mnt/merged/sys
mount -t devtmpfs devtmpfs /mnt/merged/dev
mount -t tmpfs tmpfs /mnt/merged/tmp
for dir in pts shm
do
if [ ! -e /mnt/merged/dev/$dir ] ; then
mkdir /mnt/merged/dev/$dir
fi
done
mount -t devpts devpts /mnt/merged/dev/pts
mount -t tmpfs tmpfs /mnt/merged/dev/shm
for dir in tmp run
do
if [ ! -e /mnt/merged/var/$dir ] ; then
mkdir -p /mnt/merged/var/$dir
fi
done

if [ ! -e /mnt/merged/rom ] ; then
mkdir /mnt/merged/rom
fi

pivot_root /mnt/merged /mnt/merged/rom

if [ ! -e /run/udev ] ; then
mkdir -p /run/udev
fi
