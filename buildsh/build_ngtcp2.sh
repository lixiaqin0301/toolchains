#!/bin/bash

ver=1.14.0
DESTDIR=/home/lixq/toolchains/ngtcp2-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/ngtcp2-${ver}.tar.gz ]]; then
    echo "wget https://github.com/ngtcp2/ngtcp2/releases/download/v${ver}/ngtcp2-${ver}.tar.gz"
    exit 1
fi

if [[ "$DESTDIR" == */ngtcp2-* ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" openssl nghttp3
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

cd /home/lixq/src || exit 1
rm -rf ngtcp2-${ver}
tar -xf /home/lixq/35share-rd/src/ngtcp2-${ver}.tar.gz
cd /home/lixq/src/ngtcp2-${ver} || exit 1
autoreconf -fi || exit 1
./configure --prefix=/usr --with-openssl || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */ngtcp2-* ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1

if [[ "$DESTDIR" == */ngtcp2-* ]]; then
    cd "$DESTDIR" || exit 1
    cd .. || exit 1
    rm ngtcp2
    ln -s ngtcp2-${ver} ngtcp2
fi
