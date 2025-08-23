#!/bin/bash

ver=3.8.2

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/src/bison-${ver}.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/bison/bison-${ver}.tar.xz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf bison-${ver}
tar -xf /home/lixq/src/bison-${ver}.tar.xz
cd bison-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/bison-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/bison-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/bison-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f bison
    ln -s bison-${ver} bison
fi
