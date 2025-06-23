#!/bin/bash

ver=v16.20.2

export PATH="/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/binutils/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/home/lixq/toolchains/Bear/bin"
export CC="/home/lixq/toolchains/gcc/bin/gcc"
export CXX="/home/lixq/toolchains/gcc/bin/g++"
export CCAS="/home/lixq/toolchains/gcc/bin/gcc"
export CPP="/home/lixq/toolchains/gcc/bin/cpp"
export CFLAGS="-g -I/home/lixq/toolchains/binutils/include"
export CXXFLAGS="-g -I/home/lixq/toolchains/binutils/include"
export LDFLAGS="-L/home/lixq/toolchains/gcc/lib64 -L/home/lixq/toolchains/binutils/lib -Wl,-rpath=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/binutils/lib"

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
if [[ -d /home/lixq/toolchains/node-${ver}/lib ]]; then
    cd /home/lixq/toolchains/node-${ver}/lib || exit 1
    ln -s libnode.so.* libnode.so
fi
