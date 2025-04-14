#!/usr/bin/env python
import os
import shutil
import re
import platform
import sys

FILE_LIST_COMMON="auto_release_tool_common.txt"
ROOT_PATH="../../../../../"
FOLDER_NAME="sdk_tools/"
file_list=[FILE_LIST_COMMON]

plt=platform.platform(aliased = 0,terse = 1)
plt=plt.split("-")[0]

for file in file_list:
    print(file)
    if os.path.exists(file):
        with open(file, 'r', encoding='utf-8') as save_f:
            source_lines = save_f.read().splitlines()
        for i, line in enumerate(source_lines):
            if line.split(" ")[0] == "f":
                x = line.split(" ")[1].replace("\\", "/")
                srcpath = ROOT_PATH + x
                try:
                    a = len(re.findall(r".*/([\s\S]+)", x)[0])
                except:
                    a = len(y) - 1
                dstpath = FOLDER_NAME + x[:len(x) - a - 1]
                if re.search('\*',srcpath) :
                    key=re.findall(r".*/([\s\S]+)", x)[0]
                    key=re.findall("^(.*?)\*",key)[0]
                    srcdir=ROOT_PATH+ x[:len(x) - a - 1]
                    for root, dirs, files in os.walk(srcdir):
                        for file in files:
                            # print("key,file:  ",key,file)
                            if key in file:
                                srcpath=srcdir+"/"+file
                                # print("srcpath",srcpath)
                                if not os.path.exists(dstpath):
                                    os.makedirs(dstpath)
                                if os.path.exists(srcpath):
                                    # print("f copy %s -> %s" % (srcpath, dstpath))
                                    shutil.copy(srcpath, dstpath)

                if not os.path.exists(dstpath):
                    os.makedirs(dstpath)
                if os.path.exists(srcpath):
                    # print("f copy %s -> %s" % (srcpath, dstpath))
                    shutil.copy(srcpath, dstpath)
                # print("copy %s -> %s"%(srcpath,dstpath))
            elif line.split(" ")[0] == "fr":
                x = line.split(" ")[1].replace("\\", "/")
                y = line.split(" ")[2].replace("\\", "/")
                srcpath = ROOT_PATH + x
                try:
                    dsttmp=re.findall(r".*/([\s\S]+)", y)[0]
                    srctmp=re.findall(r".*/([\s\S]+)", x)[0]
                    a = len(srctmp)
                    b = len(dsttmp)
                except:
                    a = len(y) - 1
                    b=len(x) - 1
                dstpath = FOLDER_NAME + y[:len(y) - a - 1]
                if re.search('\*',srcpath) :
                    key=re.findall(r".*/([\s\S]+)", x)[0]
                    key=re.findall("^(.*?)\*",key)[0]
                    srcdir=ROOT_PATH+ x[:len(x) - a - 1]
                    for root, dirs, files in os.walk(srcdir):
                        for file in files:
                            # print("key,file:  ",key,file)
                            if key in file:
                                srcpath=srcdir+"/"+file
                                # print("srcpath",srcpath)
                                if not os.path.exists(dstpath):
                                    os.makedirs(dstpath)
                                if os.path.exists(srcpath):
                                    # print("f copy %s -> %s" % (srcpath, dstpath))
                                    shutil.copy(srcpath, dstpath)
                                    srcname = dstpath + "/" + srctmp
                                    dstname = dstpath + "/" + dsttmp
                                    os.rename(srcname, dstname)
                                    # print("renaem %s -> %s" % (srcname, dstname))

                if not os.path.exists(dstpath):
                    os.makedirs(dstpath)
                if os.path.exists(srcpath):
                    # print("f copy %s -> %s" % (srcpath, dstpath))
                    shutil.copy(srcpath, dstpath)
                    srcname=dstpath+"/"+srctmp
                    dstname = dstpath + "/" + dsttmp
                    os.rename(srcname,dstname)
                    # print("renaem %s -> %s" % (srcname, dstname))
            elif line.split(" ")[0] == "d":
                # b = 2
                x = line.split(" ")[1].replace("\\", "/")
                srcpath = ROOT_PATH +x
                dstpath = FOLDER_NAME + x
                print(srcpath)
                print(dstpath)
                if os.path.exists(srcpath):
                    if os.path.exists(dstpath):
                        shutil.rmtree(dstpath)
                    try:
                        shutil.copytree(srcpath, dstpath, ignore=shutil.ignore_patterns('*.git'))
                        print("d copy %s -> %s" % (srcpath, dstpath))
                    except:
                        print("Dir copied failed: copy %s -> %s" % (srcpath, dstpath))
                        sys.exit(1)
                else:
                    print(f"{srcpath} do not exist!")

            elif line.split(" ")[0] == "dr":
                x = line.split(" ")[1].replace("\\", "/")
                y = line.split(" ")[2].replace("\\", "/")
                srcpath = ROOT_PATH + x
                dstpath = FOLDER_NAME + y
                if os.path.exists(srcpath):
                    if os.path.exists(dstpath):
                        shutil.rmtree(dstpath)
                    shutil.copytree(srcpath, dstpath, ignore=shutil.ignore_patterns('*.git'))
                    # print("dr copy %s -> %s" % (srcpath, dstpath))
            elif line.split(" ")[0] == "fd":
                # c = 2
                x = line.split(" ")[1].replace("\\", "/")
                srcpath = ROOT_PATH + x
                dstpath = FOLDER_NAME + x
                if os.path.exists(dstpath):
                    if os.path.isdir(dstpath):
                        shutil.rmtree(dstpath)
                    else:
                        os.remove(dstpath)
                    # print("fd %s"%(dstpath))
            elif line.split(" ")[0] == "dd":
                x = line.split(" ")[1].replace("\\", "/")
                srcpath = ROOT_PATH + x
                dstpath = FOLDER_NAME + x
                # print(dstpath)
                if os.path.exists(dstpath):
                    # print("dd %s" % (dstpath))
                    shutil.rmtree(dstpath)


