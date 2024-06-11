meta-realtek-toolchain Yocto Layer
==============================

This layer contains recipes for Realtek RSDK pre-built toolchain binaries.

Pre-built RSDK toolchain for Linux development
---------------------------------------------

Recipes for pre-built RSDK toolchain for Linux development are provided under
``recipes-devtools/external-rsdk-toolchain/``.

external-rsdk-toolchain.bb
~~~~~~~~~~~~~~~~~~~~~~~~~

This recipe provides support for pre-built RSDK GNU toolchains targeting processors
from the Arm Cortex-A family and implementing the Arm A-profile architecture.

Usage
^^^^^

In order to use any of pre-built RSDK toolchain versions (10.3.1 and so
on), a user needs to download and untar tool-set on host machine at a particular
installation path eg: ``/opt/toolchain/``. Then user needs to specify following
in ``conf/local.conf`` in order to replace OE toolchain with pre-built RSDK
toolchain:

TCMODE = "external-rsdk-toolchain"
EXTERNAL_TOOLCHAIN = "<path-to-the-toolchain>"

-  Eg.
   EXTERNAL_TOOLCHAIN = "<installation-path>/asdk-10.3.1"