#!/bin/bash

if [[ ! -f /home/lixq/toolchains/src/gdb-9.2.tar.gz ]]; then
    if ! wget http://mirrors.ustc.edu.cn/gnu/gdb/gdb-9.2.tar.gz -O /home/lixq/toolchains/src/gdb-9.2.tar.gz; then
        /bin/rm -f /home/lixq/toolchains/src/gdb-9.2.tar.gz*
        echo "Need /home/lixq/toolchains/src/gdb-9.2.tar.gz (http://mirrors.ustc.edu.cn/gnu/gdb/gdb-9.2.tar.gz)"
        exit 1
    fi
fi

cd /home/lixq/toolchains/src || exit 1
rm -rf /home/lixq/toolchains/src/gdb-9.2
tar -xvf gdb-9.2.tar.gz
mkdir /home/lixq/toolchains/src/gdb-9.2/build
cd /home/lixq/toolchains/src/gdb-9.2/build || exit 1
export CC=/home/lixq/toolchains/gcc/bin/gcc
export CXX=/home/lixq/toolchains/gcc/bin/g++
export CPP=/home/lixq/toolchains/gcc/bin/cpp
export LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64
export LD_LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64
export LD_RUN_PATH=/home/lixq/toolchains/gcc/lib64
../configure --prefix=/home/lixq/toolchains/gdb-9.2 || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/gdb-9.2
make install || exit 1
if [[ -d /home/lixq/toolchains/gdb-9.2 ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f gdb
    ln -s gdb-9.2 gdb
fi
