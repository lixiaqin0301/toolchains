#!/bin/bash

ver=1.10.0

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils

if [[ ! -f /home/lixq/35share-rd/src/libgsasl-${ver}.tar.gz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/gsasl/libgsasl-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf libgsasl-${ver}
tar -xf /home/lixq/35share-rd/src/libgsasl-${ver}.tar.gz
mkdir libgsasl-${ver}/build
cd /home/lixq/src/libgsasl-${ver}/build || exit 1
../configure --prefix=/home/lixq/toolchains/libgsasl-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/libgsasl-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/libgsasl-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f libgsasl
    ln -s libgsasl-${ver} libgsasl
fi
