#!/bin/sh
DEVICES="2 3 4 6 7 8 9 10 11"

for dev in $DEVICES; do
    flash_eraseall "/dev/mtd${dev}"
done

exit
