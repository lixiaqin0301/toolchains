#!/bin/bash

ver=1.3.1

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils

if [[ ! -f /home/lixq/35share-rd/src/zlib-${ver}.tar.xz ]]; then
    echo "wget https://github.com/madler/zlib/releases/download/v${ver}/zlib-${ver}.tar.xz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf zlib-${ver}
tar -xf /home/lixq/35share-rd/src/zlib-${ver}.tar.xz
cd zlib-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/zlib-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/zlib-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/zlib-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f zlib
    ln -s zlib-${ver} zlib
fi
