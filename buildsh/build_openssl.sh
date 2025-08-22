#!/bin/bash

name=openssl
ver=3.5.2
srcpath=/home/lixq/src/${name}-${ver}.tar.gz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ "$DESTDIR" == */${name} ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" ${name}
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf $srcpath || exit 1
cd /home/lixq/src/${name}-${ver} || exit 1
./config --prefix="$DESTDIR/usr" --libdir=lib || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install || exit 1
