#!/bin/bash

name=nghttp3
ver=1.11.0
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/${name}-${ver}.tar.gz ]]; then
    echo "wget https://github.com/ngtcp2/nghttp3/releases/download/v${ver}/${name}-${ver}.tar.gz"
    exit 1
fi

if [[ "$DESTDIR" == */${name} ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" gcc ${name}
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf /home/lixq/35share-rd/src/${name}-${ver}.tar.gz
cd /home/lixq/src/${name}-${ver} || exit 1
autoreconf -fi || exit 1
./configure --prefix="$DESTDIR/usr" || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install || exit 1
