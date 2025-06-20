#!/bin/bash

ver=v24.2.0

export PATH="/home/lixq/toolchains/glibc/usr/sbin:/home/lixq/toolchains/glibc/usr/bin:/home/lixq/toolchains/glibc/sbin:/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/binutils/bin:/home/lixq/toolchains/Miniforge3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/home/lixq/toolchains/Bear/bin"
export PKG_CONFIG_PATH="/home/lixq/toolchains/Miniforge3/lib/pkgconfig"
export CC="/home/lixq/toolchains/gcc/bin/gcc"
export CXX="/home/lixq/toolchains/gcc/bin/g++"
export CCAS="/home/lixq/toolchains/gcc/bin/gcc"
export CPP="/home/lixq/toolchains/gcc/bin/cpp"
export CFLAGS="-g -I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/Miniforge3/include --sysroot=/home/lixq/toolchains/glibc"
export CXXFLAGS="-g -I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/Miniforge3/include --sysroot=/home/lixq/toolchains/glibc"
export LDFLAGS="-L/home/lixq/toolchains/glibc/lib64 -L/home/lixq/toolchains/gcc/lib64 -L/home/lixq/toolchains/binutils/lib -L/home/lixq/toolchains/Miniforge3/lib --sysroot=/home/lixq/toolchains/glibc -Wl,-rpath=/home/lixq/toolchains/glibc/lib64:/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/binutils/lib:/home/lixq/toolchains/Miniforge3/lib -Wl,--dynamic-linker=/home/lixq/toolchains/glibc/lib64/ld-linux-x86-64.so.2"

if [[ ! -f /home/lixq/35share-rd/src/node-${ver}.tar.gz ]]; then
    echo "wget https://nodejs.org/dist/${ver}/node-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/workspace-vscode ]] || mkdir /home/lixq/workspace-vscode
cd /home/lixq/workspace-vscode || exit 1
rm -rf node-${ver}
tar -xf /home/lixq/35share-rd/src/node-${ver}.tar.gz
cd node-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/node-${ver} --shared || exit 1
bear -- make || exit 1
rm -rf /home/lixq/toolchains/node-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/node-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f node
    ln -s node-${ver} node
    cd /home/lixq/toolchains/node/lib || exit 1
    ln -s libnode.so.* libnode.so
fi
