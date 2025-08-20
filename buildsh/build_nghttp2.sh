#!/bin/bash

ver=1.66.0
DESTDIR=/home/lixq/toolchains/nghttp2-${ver}
[[ -n "$1" ]] && DESTDIR="$1"


if [[ ! -f /home/lixq/35share-rd/src/nghttp2-${ver}.tar.gz ]]; then
    echo "wget https://github.com/nghttp2/nghttp2/releases/download/v${ver}/nghttp2-${ver}.tar.gz"
    exit 1
fi

if [[ "$DESTDIR" == */nghttp2-* ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" openssl nghttp3 ngtcp2
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

cd /home/lixq/src || exit 1
rm -rf nghttp2-${ver}
tar -xf /home/lixq/35share-rd/src/nghttp2-${ver}.tar.gz
cd /home/lixq/src/nghttp2-${ver} || exit 1
./configure --prefix=/usr|| exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */nghttp2-* ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1

if [[ "$DESTDIR" == */nghttp2-* ]]; then
    cd "$DESTDIR" || exit 1
    cd .. || exit 1
    rm nghttp2
    ln -s nghttp2-${ver} nghttp2
fi
