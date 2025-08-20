#!/bin/bash

ver=3.5.2
DESTDIR=/home/lixq/toolchains/openssl-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/openssl-${ver}.tar.gz ]]; then
    echo "wget https://github.com/openssl/openssl/releases/download/openssl-${ver}/openssl-${ver}.tar.gz"
    exit 1
fi

if [[ "$DESTDIR" == */openssl-* ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" openssl
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf openssl-${ver}
tar -xf /home/lixq/35share-rd/src/openssl-${ver}.tar.gz
cd /home/lixq/src/openssl-${ver} || exit 1
./config --prefix=/usr --libdir=lib || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */openssl-* ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1

if [[ "$DESTDIR" == */openssl-* ]]; then
    cd "$DESTDIR" || exit 1
    cd .. || exit 1
    rm  -rf openssl
    ln -s openssl-${ver} openssl
fi
