#!/bin/bash

ver=1.18

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/35share-rd/src/automake-${ver}.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/automake/automake-${ver}.tar.xz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf automake-${ver}
tar -xf /home/lixq/35share-rd/src/automake-${ver}.tar.xz
cd automake-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/automake-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/automake-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/automake-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f automake
    ln -s automake-${ver} automake
fi
