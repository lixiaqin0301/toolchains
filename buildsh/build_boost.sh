#!/bin/bash

name=boost
ver=1_89_0
srcpath=/home/lixq/src/${name}_${ver}.tar.gz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ "$DESTDIR" == */${name} ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" gcc
    export PATH="/home/lixq/toolchains/patchelf/usr/bin:$PATH"
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}_${ver}
tar -xf $srcpath || exit 1
cd ${name}_${ver} || exit 1
./bootstrap.sh --prefix="$DESTDIR/usr" || exit 1
patchelf --set-rpath /home/lixq/toolchains/gcc/usr/lib64:lib64 ./b2 || exit 1
./b2 cxxflags="$CXXFLAGS" linkflags="$LDFLAGS" -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
./b2 cxxflags="$CXXFLAGS" linkflags="$LDFLAGS" -s -j"$(nproc)" install || exit 1
