#!/bin/bash

name=rtmpdump
ver=2.3
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/${name}-${ver}.tgz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/libidn/${name}-${ver}.tgz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf /home/lixq/35share-rd/src/${name}-${ver}.tgz
cd ${name}-${ver} || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
[[ -d "$DESTDIR/usr/lib" ]] || mkdir -p "$DESTDIR/usr/lib"
make -s -j"$(nproc)" install prefix=/usr DESTDIR="$DESTDIR" || exit 1
