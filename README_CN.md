<div align="center">

<img src="docs/linux.png" alt="ameba-linux meta-realtek" width="800">

# meta-realtek

**Realtek Ameba SoC 的 Yocto 集成层 —— 把 ameba-linux 源码组装成可烧录镜像的胶水层。**

[![SDK](https://badgen.net/badge/SDK/ameba--linux/blue)](https://aiot.realmcu.com/zh/latest/linux/index.html)
[![Yocto](https://badgen.net/badge/Yocto/wrynose%2B/blue)](https://www.yoctoproject.org/)
[![License](https://badgen.net/badge/License/MIT/lightgrey)](meta-realtek-bsp/COPYING.MIT)

[English](README.md) · [中文版](README_CN.md) · [Linux SDK 文档](https://aiot.realmcu.com/zh/latest/linux/index.html)

</div>

`meta-realtek` 是 Yocto/OpenEmbedded 元层，负责把 ameba-linux SDK（kernel、U-Boot、ATF、协处理器固件、用户态守护进程、Realtek IP、镜像、发布工具）打包成 **RTL8730E** 家族（VA6 / VA7 / VA8 + recovery）可烧录的产品镜像。

它叠加在 `poky`、`meta-openembedded`、`meta-swupdate`、`meta-realtek-matter` 之上（见 `sources/yocto/meta-realtek` 的同级目录），由 `6.18.y/` 顶层 `envsetup.sh` 驱动。

## 🧭 在 SDK 中的位置

```text
┌──────────────────────────────────────────────────────────────┐
│  Yocto 镜像  (build_<machine>_<distro>/tmp/deploy/images/)   │
│      kernel + rootfs + bootloader + 协处理器固件             │
├──────────────────────────────────────────────────────────────┤
│  meta-realtek  ← 本层                                        │
│     ├─ meta-realtek-bsp   BSP：kernel、u-boot、ATF、OE recipe │
│     ├─ meta-sdk           Realtek 中间件：aivoice/tflite/…    │
│     └─ tools              envsetup 辅助、发布脚本             │
├──────────────────────────────────────────────────────────────┤
│  meta-openembedded / poky / meta-swupdate（上游层）           │
├──────────────────────────────────────────────────────────────┤
│  源码树：sources/{kernel, firmware, development, tests}       │
└──────────────────────────────────────────────────────────────┘
```

## 🏗️ 层目录结构

```text
meta-realtek/
├── meta-realtek-bsp/                    # BSP（Board Support Package）
│   ├── conf/machine/                    #   Machine 配置（VA6/VA7/VA8、recovery）
│   │   ├── rtl8730eah-va6.conf
│   │   ├── rtl8730eam-va6.conf
│   │   ├── rtl8730elm-va7.conf
│   │   ├── rtl8730elm-va8.conf
│   │   └── rtl8730e-recovery.conf
│   ├── recipes-bsp/
│   │   ├── u-boot/                      #   U-Boot（bootloader）
│   │   ├── atf/                         #   ARM Trusted Firmware（BL31）
│   │   └── firmware/                    #   协处理器固件（打包 sources/firmware/）
│   ├── recipes-kernel/linux/            #   Linux 6.18 kernel recipe + defconfig/DTS
│   ├── recipes-connectivity/            #   Wi-Fi / BT / OpenThread 包
│   │   ├── wpa-supplicant/
│   │   ├── hostapd/
│   │   ├── bluez5/
│   │   ├── hciattach/                   #   → sources/development/bluetooth/hciattach
│   │   ├── mbedtls/
│   │   ├── openthread/
│   │   ├── rtwperf/                     #   → sources/development/wifi/rtwperf
│   │   ├── wireless-tools/
│   │   └── wpa-supplicant/
│   ├── recipes-multimedia/              #   ALSA、PipeWire、WirePlumber
│   ├── recipes-development/             #   sources/development/* 工具的 recipe
│   │   ├── adbd/  atwz/  captouch/  efuse/  getevent/
│   │   ├── km4_console/  otp_ipc/  recovery/  rtlbtmp/  rtwpriv/
│   ├── recipes-core/                    #   busybox、sysvinit、init-ifupdown、udev、initscripts、packagegroups
│   ├── recipes-test/                    #   sources/tests/* 的打包 recipe
│   ├── recipes-graphics/                #   图形栈（framebuffer / DRM）
│   └── recipes-security/                #   安全 / 加密库
│
├── meta-sdk/                            # Realtek 中间件与上层服务
│   ├── conf/
│   │   ├── distro/                      #   ameba-full、ameba-generic 等
│   │   ├── projects/                    #   Project 模板（envsetup.sh 使用）
│   │   └── templates/
│   ├── recipes-core/
│   │   ├── images/                      #   镜像 recipe（rootfs 组合）
│   │   └── base-files/
│   ├── recipes-rtk/                     #   Realtek IP recipe
│   │   ├── aivoice/                     #   → sources/development/apps/aivoice
│   │   ├── tflite/                      #   → sources/development/tflite
│   │   ├── gui/                         #   LVGL / GUI 栈
│   │   ├── recoveryd/                   #   → sources/development/recovery/recoveryd
│   │   ├── fwk/                         #   应用框架
│   │   └── rtk-rc-local/                #   /etc/rc.local 钩子
│   └── recipes-support/swupdate/        #   SWUpdate OTA 集成
│
└── tools/                               # 层级工具
    ├── envsetup.sh                      #   由顶层 envsetup.sh source
    ├── firmware.sh                      #   协处理器固件辅助脚本（mfw）
    ├── install.sh                       #   层安装器
    ├── release_tool/                    #   发布打包脚本
    ├── sdk/                             #   SDK 辅助工具
    ├── swupdate/                        #   SWUpdate 资产
    ├── u-boot-env/                      #   预定义 U-Boot 环境变量
    └── verified_boot/                   #   Secure/verified boot 密钥与工具
```

## ✨ 主要交付物

- **Machine** — RTL8730E VA6 / VA7 / VA8（+ recovery 变体），各自配套 DTS + defconfig。
- **启动链** — ATF (BL31) + U-Boot + Linux 6.18 内核 + 协处理器固件（由 `sources/firmware/` 打包）。
- **Distro** — `meta-sdk/conf/distro/` 下的 `ameba-full`（功能齐全的参考镜像）和 `ameba-generic`（精简）。
- **中间件** — AI 语音、TFLite 运行时、LVGL GUI、PipeWire/ALSA/WirePlumber 音频、recovery 守护进程。
- **连接性** — wpa-supplicant、hostapd、BlueZ5、`hciattach`、OpenThread、`rtwperf`/`rtwpriv`。
- **OTA** — 通过 `meta-sdk/recipes-support/swupdate/` 与 `tools/swupdate/` 集成 SWUpdate。
- **安全** — 在 `tools/verified_boot/` 下管理 verified boot 密钥与工具。
- **量产** — 通过 `tools/release_tool/` 发布打包；通过 `tools/u-boot-env/` 提供 U-Boot 环境模板。

## 🚀 构建入口

本层始终由 SDK 根目录（`6.18.y/`）的 `envsetup.sh` 驱动，`envsetup.sh` 会 source `meta-realtek/tools/envsetup.sh` 并导出下列 shell helper：

```bash
# 1. 按 machine + distro 拉起环境
source envsetup.sh -m rtl8730elm-va8 -d ameba-full   # VA8 full
source envsetup.sh -m rtl8730elm-va7 -d ameba-full   # VA7 full
source envsetup.sh -m rtl8730eah-va6 -d ameba-full   # VA6 full
source envsetup.sh -m rtl8730eah-va6 -d ameba-generic

# 2. 列出可用 machine 与 distro
lconfig

# 3. 构建
m                # 完整镜像
mkernel          # 内核（增量）
mkernel clean    # 内核（全量重建）
mfw              # 协处理器 Wi-Fi 固件
mfw mp           # 协处理器 MP 固件
mfw menuconfig   # 协处理器 Kconfig
mrecovery        # Recovery 镜像

# 4. 目录快捷键
croot            # SDK 根
clinux           # 内核源码
cyocto           # Yocto 层

# 5. Grep 快捷键
cgrep <kw>       # C/C++
mgrep <kw>       # Makefile / *.mk
```

单独重编某个包用普通 bitbake：

```bash
bitbake -c cleanall <pkg>
bitbake <pkg>
```

构建产物落到 `build_<machine>_<distro>/tmp/deploy/images/<machine>/`（VA8 输出还挂了固定符号链接 `6.18.y/images/`）。

## 🔗 交叉引用

- 协处理器固件源码：[`sources/firmware/`](../../firmware)
- Linux 用户态源码：[`sources/development/`](../../development)
- 外设测试源码：[`sources/tests/`](../../tests)
- 内核源码：`sources/kernel/`

## 📚 文档

- **Ameba Linux SDK 用户指南** — https://aiot.realmcu.com/zh/latest/linux/index.html
- **Yocto Project** — https://docs.yoctoproject.org/

## 📝 备注

若要把本层手动加入 bitbake 构建：

```bash
bitbake-layers add-layer path/to/meta-realtek/meta-realtek-bsp
bitbake-layers add-layer path/to/meta-realtek/meta-sdk
```

顶层 `envsetup.sh` 选择 project 时会自动完成该步骤。

## 💬 反馈

社区：[Real-AIOT 论坛](https://forum.real-aiot.com/)
