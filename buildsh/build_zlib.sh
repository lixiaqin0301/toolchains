#!/bin/bash

ver=1.3.1
DESTDIR=/home/lixq/toolchains/zlib-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/zlib-${ver}.tar.gz ]]; then
    echo "wget https://github.com/madler/zlib/releases/download/v${ver}/zlib-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf zlib-${ver}
tar -xf /home/lixq/35share-rd/src/zlib-${ver}.tar.gz
cd zlib-${ver} || exit 1
./configure --prefix=/usr || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */zlib-* ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1

if [[ "$DESTDIR" == */zlib-* ]]; then
    cd "$DESTDIR" || exit 1
    cd .. || exit 1
    rm -f zlib
    ln -s zlib-${ver} zlib
fi
