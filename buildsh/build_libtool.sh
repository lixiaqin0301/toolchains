#!/bin/bash

ver=2.5.4

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/35share-rd/src/libtool-${ver}.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/libtool/libtool-${ver}.tar.xz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf libtool-${ver}
tar -xf /home/lixq/35share-rd/src/libtool-${ver}.tar.xz
cd libtool-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/libtool-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/libtool-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/libtool-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f libtool
    ln -s libtool-${ver} libtool
fi
