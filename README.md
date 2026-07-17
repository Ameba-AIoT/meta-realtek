<div align="center">

<img src="docs/linux.png" alt="ameba-linux meta-realtek" width="800">

# meta-realtek

**Yocto integration layer for Realtek Ameba SoCs — the glue that assembles the ameba-linux sources into flashable images.**

[![SDK](https://badgen.net/badge/SDK/ameba--linux/blue)](https://aiot.realmcu.com/en/latest/linux/index.html)
[![Yocto](https://badgen.net/badge/Yocto/wrynose%2B/blue)](https://www.yoctoproject.org/)
[![License](https://badgen.net/badge/License/MIT/lightgrey)](meta-realtek-bsp/COPYING.MIT)

[English](README.md) · [中文版](README_CN.md) · [Linux SDK Docs](https://aiot.realmcu.com/en/latest/linux/index.html)

</div>

`meta-realtek` is a Yocto/OpenEmbedded meta-layer that packages the ameba-linux SDK (kernel, U-Boot, ATF, co-processor firmware, user-space daemons, Realtek IP, images, release tools) into flashable product images for the **RTL8730E** family (VA6 / VA7 / VA8 + recovery).

It stacks on top of `poky`, `meta-openembedded`, `meta-swupdate`, and `meta-realtek-matter` (see the siblings of `sources/yocto/meta-realtek`) and is driven by the top-level `envsetup.sh` under `6.18.y/`.

## 🧭 Position in the SDK

```text
┌──────────────────────────────────────────────────────────────┐
│  Yocto image  (build_<machine>_<distro>/tmp/deploy/images/)  │
│      kernel + rootfs + bootloader + co-processor firmware    │
├──────────────────────────────────────────────────────────────┤
│  meta-realtek  ← this layer                                  │
│     ├─ meta-realtek-bsp   BSP: kernel, u-boot, ATF, OE recipes│
│     ├─ meta-sdk           Realtek middleware: aivoice/tflite/…│
│     └─ tools              envsetup helper, release scripts    │
├──────────────────────────────────────────────────────────────┤
│  meta-openembedded / poky / meta-swupdate (upstream layers)   │
├──────────────────────────────────────────────────────────────┤
│  Source tree: sources/{kernel, firmware, development, tests}  │
└──────────────────────────────────────────────────────────────┘
```

## 🏗️ Layer layout

```text
meta-realtek/
├── meta-realtek-bsp/                    # BSP (Board Support Package)
│   ├── conf/machine/                    #   Machine configs (VA6/VA7/VA8, recovery)
│   │   ├── rtl8730eah-va6.conf
│   │   ├── rtl8730eam-va6.conf
│   │   ├── rtl8730elm-va7.conf
│   │   ├── rtl8730elm-va8.conf
│   │   └── rtl8730e-recovery.conf
│   ├── recipes-bsp/
│   │   ├── u-boot/                      #   U-Boot (bootloader)
│   │   ├── atf/                         #   ARM Trusted Firmware (BL31)
│   │   └── firmware/                    #   Co-processor firmware (packages sources/firmware/)
│   ├── recipes-kernel/linux/            #   Linux 6.18 kernel recipe + defconfig/DTS
│   ├── recipes-connectivity/            #   Wi-Fi / BT / OpenThread packages
│   │   ├── wpa-supplicant/
│   │   ├── hostapd/
│   │   ├── bluez5/
│   │   ├── hciattach/                   #   → sources/development/bluetooth/hciattach
│   │   ├── mbedtls/
│   │   ├── openthread/
│   │   ├── rtwperf/                     #   → sources/development/wifi/rtwperf
│   │   ├── wireless-tools/
│   │   └── wpa-supplicant/
│   ├── recipes-multimedia/              #   ALSA, PipeWire, WirePlumber
│   ├── recipes-development/             #   Recipes for the tools in sources/development/*
│   │   ├── adbd/  atwz/  captouch/  efuse/  getevent/
│   │   ├── km4_console/  otp_ipc/  recovery/  rtlbtmp/  rtwpriv/
│   ├── recipes-core/                    #   busybox, sysvinit, init-ifupdown, udev, initscripts, packagegroups
│   ├── recipes-test/                    #   Packaging recipes for sources/tests/*
│   ├── recipes-graphics/                #   Graphics stack (framebuffer / DRM)
│   └── recipes-security/                #   Security / crypto libraries
│
├── meta-sdk/                            # Realtek middleware and upper-layer services
│   ├── conf/
│   │   ├── distro/                      #   ameba-full, ameba-generic, etc.
│   │   ├── projects/                    #   Project templates (used by envsetup.sh)
│   │   └── templates/
│   ├── recipes-core/
│   │   ├── images/                      #   Image recipes (rootfs composition)
│   │   └── base-files/
│   ├── recipes-rtk/                     #   Realtek IP recipes
│   │   ├── aivoice/                     #   → sources/development/apps/aivoice
│   │   ├── tflite/                      #   → sources/development/tflite
│   │   ├── gui/                         #   LVGL / GUI stack
│   │   ├── recoveryd/                   #   → sources/development/recovery/recoveryd
│   │   ├── fwk/                         #   Application framework
│   │   └── rtk-rc-local/                #   /etc/rc.local hook
│   └── recipes-support/swupdate/        #   SWUpdate OTA integration
│
└── tools/                               # Layer-level tools
    ├── envsetup.sh                      #   Sourced by the top-level envsetup.sh
    ├── firmware.sh                      #   Co-processor firmware helper (mfw)
    ├── install.sh                       #   Layer installer
    ├── release_tool/                    #   Release-packaging scripts
    ├── sdk/                             #   SDK helper tools
    ├── swupdate/                        #   SWUpdate assets
    ├── u-boot-env/                      #   Pre-defined U-Boot environment
    └── verified_boot/                   #   Secure/verified boot keys & tools
```

## ✨ Key deliverables

- **Machines** — RTL8730E VA6 / VA7 / VA8 (+ recovery variants), each with matching DTS and defconfig.
- **Boot chain** — ATF (BL31) + U-Boot + Linux 6.18 kernel + co-processor firmware (packaged from `sources/firmware/`).
- **Distros** — `ameba-full` (feature-complete reference image) and `ameba-generic` (slim) under `meta-sdk/conf/distro/`.
- **Middleware** — AI voice, TFLite runtime, LVGL GUI, PipeWire/ALSA/WirePlumber audio, recovery daemon.
- **Connectivity** — wpa-supplicant, hostapd, BlueZ5, `hciattach`, OpenThread, `rtwperf` / `rtwpriv`.
- **OTA** — SWUpdate integration via `meta-sdk/recipes-support/swupdate/` and `tools/swupdate/`.
- **Security** — verified-boot keys and tools under `tools/verified_boot/`.
- **Production** — release packaging via `tools/release_tool/`; U-Boot environment templates via `tools/u-boot-env/`.

## 🚀 Build entry point

This layer is always driven by the SDK-root (`6.18.y/`) `envsetup.sh`, which sources `meta-realtek/tools/envsetup.sh` and exports the following shell helpers:

```bash
# 1. Bring up the environment for a machine + distro
source envsetup.sh -m rtl8730elm-va8 -d ameba-full   # VA8 full
source envsetup.sh -m rtl8730elm-va7 -d ameba-full   # VA7 full
source envsetup.sh -m rtl8730eah-va6 -d ameba-full   # VA6 full
source envsetup.sh -m rtl8730eah-va6 -d ameba-generic

# 2. List available machines and distros
lconfig

# 3. Build
m                # Full image
mkernel          # Kernel (incremental)
mkernel clean    # Kernel (full rebuild)
mfw              # Co-processor Wi-Fi firmware
mfw mp           # Co-processor MP firmware
mfw menuconfig   # Co-processor Kconfig
mrecovery        # Recovery image

# 4. Directory shortcuts
croot            # SDK root
clinux           # Kernel source
cyocto           # Yocto layer

# 5. Grep shortcuts
cgrep <kw>       # C/C++
mgrep <kw>       # Makefile / *.mk
```

Rebuild a single package with plain bitbake:

```bash
bitbake -c cleanall <pkg>
bitbake <pkg>
```

Build artefacts land in `build_<machine>_<distro>/tmp/deploy/images/<machine>/` (VA8 output also has a fixed symlink at `6.18.y/images/`).

## 🔗 Cross references

- Co-processor firmware source: [`sources/firmware/`](../../firmware)
- Linux user-space source: [`sources/development/`](../../development)
- Peripheral test source: [`sources/tests/`](../../tests)
- Kernel source: `sources/kernel/`

## 📚 Documentation

- **Ameba Linux SDK User Guide** — https://aiot.realmcu.com/en/latest/linux/index.html
- **Yocto Project** — https://docs.yoctoproject.org/

## 📝 Notes

To add this layer to a bitbake build manually:

```bash
bitbake-layers add-layer path/to/meta-realtek/meta-realtek-bsp
bitbake-layers add-layer path/to/meta-realtek/meta-sdk
```

The top-level `envsetup.sh` does this automatically when a project is selected.

## 💬 Feedback

Community: [Real-AIOT Forum](https://forum.real-aiot.com/)
