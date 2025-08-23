#!/bin/bash

ver=4.4.1
DESTDIR=/home/lixq/toolchains/make-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

if [[ ! -f /home/lixq/src/make-${ver}.tar.gz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/make/make-${ver}.tar.gz"
    exit 1
fi

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf make-${ver}
tar -xf /home/lixq/src/make-${ver}.tar.gz
cd make-${ver} || exit 1
./configure --prefix=/usr || exit 1
make -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */make-* ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1
cd "$DESTDIR/usr/bin" || exit 1
ln -s make gmake

if [[ "$DESTDIR" == */make-* ]]; then
    cd "${DESTDIR}" || exit 1
    cd .. || exit 1
    rm -f make
    ln -s make-${ver} make
fi
