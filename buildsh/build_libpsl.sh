#!/bin/bash

ver=0.21.5

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils

if [[ ! -f /home/lixq/35share-rd/src/libpsl-${ver}.tar.gz ]]; then
    echo "wget https://github.com/rockdaboot/libpsl/releases/download/${ver}/libpsl-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf libpsl-${ver}
tar -xf /home/lixq/35share-rd/src/libpsl-${ver}.tar.gz
mkdir libpsl-${ver}/build
cd /home/lixq/src/libpsl-${ver}/build || exit 1
../configure --prefix=/home/lixq/toolchains/libpsl-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/libpsl-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/libpsl-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f libpsl
    ln -s libpsl-${ver} libpsl
fi
