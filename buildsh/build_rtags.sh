#!/bin/bash

[[ -d /home/lixq/toolchains/src ]] || mkdir -p /home/lixq/toolchains/src

if [[ ! -f /home/lixq/toolchains/src/rtags-2.38.tar.bz2 ]]; then
    if ! wget https://github.com.cnpmjs.org/Andersbakken/rtags/releases/download/v2.38/rtags-2.38.tar.bz2 -O /home/lixq/toolchains/src/rtags-2.38.tar.bz2; then
        /bin/rm -f /home/lixq/toolchains/src/rtags-2.38.tar.bz2*
        echo "Need /home/lixq/toolchains/src/rtags-2.38.tar.bz2 (https://github.com/Andersbakken/rtags/releases/download/v2.38/rtags-2.38.tar.bz2)"
        exit 1
    fi
fi

cd /home/lixq/toolchains/src || exit 1
rm -rf rtags-2.38 /home/lixq/toolchains/rtags-2.38
tar -xvf rtags-2.38.tar.bz2
mkdir /home/lixq/toolchains/src/rtags-2.38/build
cd /home/lixq/toolchains/src/rtags-2.38/build || exit 1

export PATH=$PATH:/home/lixq/toolchains/llvm/bin
export CXX=/home/lixq/toolchains/gcc/bin/g++
export LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/llvm/lib
export LD_LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/llvm/lib
export LD_RUN_RPATH=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/llvm/lib
/home/lixq/toolchains/cmake/bin/cmake \
    -DCMAKE_C_COMPILER=/home/lixq/toolchains/gcc/bin/gcc \
    -DCMAKE_CXX_COMPILER=/home/lixq/toolchains/gcc/bin/g++ \
    -DCMAKE_LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/llvm/lib \
    -DCMAKE_INSTALL_RPATH=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/llvm/lib \
    -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/rtags-2.38 \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
    .. || exit 1
make || exit 1
make install || exit 1
if [[ -d /home/lixq/toolchains/rtags-2.38 ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f rtags
    ln -s rtags-2.38 rtags
fi
