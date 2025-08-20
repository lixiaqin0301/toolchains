#!/bin/bash

ver=1.11.0
DESTDIR=/home/lixq/toolchains/nghttp3-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/nghttp3-${ver}.tar.gz ]]; then
    echo "wget https://github.com/ngtcp2/nghttp3/releases/download/v${ver}/nghttp3-${ver}.tar.gz"
    exit 1
fi

if [[ "$DESTDIR" == */nghttp3-* ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" gcc
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

cd /home/lixq/src || exit 1
rm -rf nghttp3-${ver}
tar -xf /home/lixq/35share-rd/src/nghttp3-${ver}.tar.gz
cd /home/lixq/src/nghttp3-${ver} || exit 1
autoreconf -fi || exit 1
./configure --prefix=/usr || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */nghttp3-* ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1

if [[ "$DESTDIR" == */nghttp3-* ]]; then
    cd "$DESTDIR" || exit 1
    cd .. || exit 1
    rm nghttp3
    ln -s nghttp3-${ver} nghttp3
fi
