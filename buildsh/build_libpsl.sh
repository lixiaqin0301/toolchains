#!/bin/bash

ver=0.21.5
DESTDIR=/home/lixq/toolchains/libpsl-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/libpsl-${ver}.tar.gz ]]; then
    echo "wget https://github.com/rockdaboot/libpsl/releases/download/${ver}/libpsl-${ver}.tar.gz"
    exit 1
fi

if [[ "$DESTDIR" == */libpsl-* ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" libpsl
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf libpsl-${ver}
tar -xf /home/lixq/35share-rd/src/libpsl-${ver}.tar.gz
mkdir libpsl-${ver}/build
cd /home/lixq/src/libpsl-${ver}/build || exit 1
../configure --prefix=/usr || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */libpsl-* ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1

if [[ "$DESTDIR" == */libpsl-* ]]; then
    cd "$DESTDIR" || exit 1
    cd .. || exit 1
    rm -f libpsl
    ln -s libpsl-${ver} libpsl
fi
