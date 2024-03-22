#!/bin/bash

ver=14.2

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/35share-rd/src/gdb-${ver}.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/gdb/gdb-${ver}.tar.xz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf gdb-${ver}
tar -xvf /home/lixq/35share-rd/src/gdb-${ver}.tar.xz
mkdir gdb-${ver}/build
cd gdb-${ver}/build || exit 1
../configure --prefix=/home/lixq/toolchains/gdb-${ver} --with-lzma || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/gdb-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/gdb-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f gdb
    ln -s gdb-${ver} gdb
fi
