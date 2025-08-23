#!/bin/bash

ver=5.8.1

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils

if [[ ! -f /home/lixq/src/xz-${ver}.tar.xz ]]; then
    echo "wget https://github.com/tukaani-project/xz/releases/download/v${ver}/xz-${ver}.tar.xz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf xz-${ver}
tar -xf /home/lixq/src/xz-${ver}.tar.xz
cd xz-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/xz-${ver} || exit 1
make -j"$(nproc)" || exit 1
rm -rf /home/lixq/toolchains/xz-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/xz-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f xz
    ln -s xz-${ver} xz
fi
