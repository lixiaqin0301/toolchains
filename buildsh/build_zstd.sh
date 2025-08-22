#!/bin/bash

name=zstd
ver=1.5.7
srcpath=/home/lixq/src/${name}-${ver}.tar.gz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf $srcpath || exit 1
cd ${name}-${ver} || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="${DESTDIR}" PREFIX=/usr || exit 1
