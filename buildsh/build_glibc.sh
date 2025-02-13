#!/bin/bash

ver=2.41

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/35share-rd/src/glibc-${ver}.tar.xz ]]; then
    echo "wget https://mirrors.ustc.edu.cn/gnu/glibc/glibc-${ver}.tar.xz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf glibc-${ver}
tar -xvf /home/lixq/35share-rd/src/glibc-${ver}.tar.xz
mkdir glibc-${ver}/build
cd glibc-${ver}/build || exit 1
../configure --prefix=/home/lixq/toolchains/glibc-${ver} || exit 1
make -j32 || exit 1
rm -rf /home/lixq/toolchains/glibc-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/glibc-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f glibc
    ln -s glibc-${ver} glibc
    cd /home/lixq/toolchains/glibc/lib || exit 1
    ln -s /home/lixq/toolchains/gcc/lib64/libstdc++.so.6
    ln -s /home/lixq/toolchains/gcc/lib64/libgcc_s.so.1
fi
