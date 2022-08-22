#!/bin/bash

ver=12.1

if [[ ! -f /home/lixq/src/gdb-${ver}.tar.gz ]]; then
    if ! wget http://mirrors.ustc.edu.cn/gnu/gdb/gdb-${ver}.tar.gz -O /home/lixq/src/gdb-${ver}.tar.gz; then
        /bin/rm -f /home/lixq/src/gdb-${ver}.tar.gz*
        echo "Need /home/lixq/src/gdb-${ver}.tar.gz (http://mirrors.ustc.edu.cn/gnu/gdb/gdb-${ver}.tar.gz)"
        exit 1
    fi
fi

cd /home/lixq/src || exit 1
rm -rf /home/lixq/src/gdb-${ver}
tar -xvf gdb-${ver}.tar.gz
mkdir /home/lixq/src/gdb-${ver}/build
cd /home/lixq/src/gdb-${ver}/build || exit 1
export CC=/home/lixq/toolchains/gcc/bin/gcc
export CXX=/home/lixq/toolchains/gcc/bin/g++
export CPP=/home/lixq/toolchains/gcc/bin/cpp
export LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64
export LD_LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64
export LD_RUN_PATH=/home/lixq/toolchains/gcc/lib64
../configure --prefix=/home/lixq/toolchains/gdb-${ver} --with-lzma || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/gdb-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/gdb-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f gdb
    ln -s gdb-${ver} gdb
fi
