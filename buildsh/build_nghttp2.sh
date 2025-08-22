#!/bin/bash

name=nghttp2
ver=1.66.0
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/src/${name}-${ver}.tar.gz ]]; then
    echo "wget https://github.com/nghttp2/nghttp2/releases/download/v${ver}/${name}-${ver}.tar.gz"
    exit 1
fi

if [[ "$DESTDIR" == */${name} ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" openssl nghttp3 ngtcp2 ${name}
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf /home/lixq/src/${name}-${ver}.tar.gz
cd /home/lixq/src/${name}-${ver} || exit 1
./configure --prefix="$DESTDIR/usr" || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install || exit 1
