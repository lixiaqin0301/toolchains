#!/bin/bash

ver=2.44

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/35share-rd/src/binutils-${ver}.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/binutils/binutils-${ver}.tar.xz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf binutils-${ver}
tar -xf /home/lixq/35share-rd/src/binutils-${ver}.tar.xz
cd binutils-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/binutils-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/binutils-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/binutils-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f binutils
    ln -s binutils-${ver} binutils
fi
