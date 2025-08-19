#!/bin/bash

ver=2.45
DESTDIR=/home/lixq/toolchains/binutils-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/binutils-${ver}.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/binutils/binutils-${ver}.tar.xz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf binutils-${ver}
tar -xf /home/lixq/35share-rd/src/binutils-${ver}.tar.xz
cd binutils-${ver} || exit 1
./configure --prefix=/usr || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */binutils-* ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1

if [[ "$DESTDIR" == */make-* ]]; then
    cd "$DESTDIR" || exit 1
    cd .. || exit 1
    rm -f binutils
    ln -s binutils-${ver} binutils
fi
