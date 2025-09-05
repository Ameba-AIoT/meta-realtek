#!/bin/sh

entry_value=$(fw_printenv | grep '^entry=')

if [ -n "$entry_value" ]; then
    value=${entry_value#entry=}
    if [ "$value" = "normal" ]; then
        echo "set entry to recovery"
        /usr/bin/fw_setenv entry recovery
        sync
        sleep 3
        reboot
    else
        echo "set entry to normal"
        /usr/bin/fw_setenv entry normal
    fi
fi

exit
