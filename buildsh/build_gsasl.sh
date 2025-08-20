#!/bin/bash

ver=2.2.2
DESTDIR=/home/lixq/toolchains/gsasl-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/gsasl-${ver}.tar.gz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/gsasl/gsasl-${ver}.tar.gz"
    exit 1
fi

if [[ "$DESTDIR" == */gsasl-* ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" gsasl
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf gsasl-${ver}
tar -xf /home/lixq/35share-rd/src/gsasl-${ver}.tar.gz
mkdir gsasl-${ver}/build
cd /home/lixq/src/gsasl-${ver}/build || exit 1
../configure --prefix=/usr || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */gsasl-* ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1

if [[ "$DESTDIR" == */gsasl-* ]]; then
    cd "$DESTDIR" || exit 1
    cd .. || exit 1
    rm -f gsasl
    ln -s gsasl-${ver} gsasl
fi
