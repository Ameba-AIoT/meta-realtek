#! /usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (c) 2024 Realtek Semiconductor Corp.
# SPDX-License-Identifier: Apache-2.0

import os
import sys
import subprocess
import argparse
import shutil
import re
import time

ROOTDIR = '../../../../../tools/ameba'
CD_ROOTDIR = 'cd ' + ROOTDIR + ' && '


def main(argc, argv):
    parser = argparse.ArgumentParser(description=None)
    parser.add_argument(
        "-v",
        "--version",
        default="",
        help="sdk tools version, e.g. release_tool.py [-v 11.0a-alpha]"
    )
    args = parser.parse_args()
    now = time.strftime("%Y%m%d_%H%M%S", time.localtime(time.time()))

    TARGET_FOLDER = 'sdk_tools_' + now
    print('version to release: ' + TARGET_FOLDER)

    # copy files
    subprocess.run('python auto_release_tool.py', shell = True, check = True)

    if os.path.exists(TARGET_FOLDER):
        shutil.rmtree(TARGET_FOLDER)

    shutil.move('sdk_tools', TARGET_FOLDER)

    # tar
    subprocess.run('tar -zcvf ' +  TARGET_FOLDER + '.tgz ' + TARGET_FOLDER, shell = True, check = True)
    shutil.rmtree(TARGET_FOLDER)

if __name__ == '__main__':
    main(len(sys.argv), sys.argv[1:])
