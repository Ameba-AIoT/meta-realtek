DESCRIPTION = "Realtek Test Packagegroup"
LICENSE = "CLOSED"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = "\
    rtk-app-adc-test \
    rtk-app-audio-pll-test \
    rtk-app-captouch-test \
    rtk-app-gpio-sysfs-test \
    rtk-app-gpio-cdev-test \
    rtk-app-gpio-uio-test \
    rtk-app-hello-test \
    rtk-app-i2c-test \
    rtk-app-ir-test \
    rtk-app-ledc-test \
    rtk-app-misc-test \
    rtk-app-pm-wakelock-test \
    rtk-app-pm-wakeup-count-test \
    rtk-app-pwm-test \
    rtk-app-rtc-test \
    rtk-app-sdioh-test \
    rtk-app-spi-test \
    rtk-app-spic-test \
    rtk-app-thermal-test \
    rtk-app-uart-test \
    rtk-app-usbh-cdc-acm-test \
    rtk-app-usbh-uvc-test \
    rtk-app-usbh-vendor-test \
    rtk-app-watchdog-test \
    rtk-benchmark-stream \
    rtk-benchmark-lmbench \
    rtk-app-drm-mode-test \
    rtk-app-drm-mode-print \
    rtk-app-drm-prop-test \
    rtk-app-drm-kms-test \
    rtk-app-drm-libkms-test \
    rtk-app-drm-vbl-test \
    rtk-app-cpu-test \
    rtk-app-system-timer-test \
    rtk-gui \
    kmod-crypto \
    kmod-timer \
    kmod-hello-module \
    kmod-i2c-slave \
    kmod-gpio \
    kmod-dmac \
"
