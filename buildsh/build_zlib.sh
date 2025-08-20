#!/bin/bash

name=zlib
ver=1.3.1
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/${name}-${ver}.tar.gz ]]; then
    echo "wget https://github.com/madler/zlib/releases/download/v${ver}/${name}-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf /home/lixq/35share-rd/src/${name}-${ver}.tar.gz
cd ${name}-${ver} || exit 1
./configure --prefix="$DESTDIR/usr" || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install || exit 1
