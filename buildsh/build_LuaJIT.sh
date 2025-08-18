#!/bin/bash

ver=2.1.ROLLING
DESTDIR=/home/lixq/toolchains/LuaJIT-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/LuaJIT-${ver}.tar.gz ]]; then
    echo "wget https://github.com/LuaJIT/LuaJIT/archive/refs/tags/v2.1.ROLLING.tar.gz -O LuaJIT-2.1.ROLLING.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf LuaJIT-${ver}
tar -xf /home/lixq/35share-rd/src/LuaJIT-${ver}.tar.gz
cd /home/lixq/src/LuaJIT-${ver} || exit 1
make -s -j"$(nproc)" || exit 1
rm -rf "${DESTDIR}"
make -s -j"$(nproc)" install DESTDIR="${DESTDIR}" || exit 1
cd "${DESTDIR}" || exit 1
if [[ "$(basename "${DESTDIR}")" == LuaJIT-${ver} ]]; then
    cd "${DESTDIR}" || exit 1
    cd .. || exit 1
    rm -f LuaJIT
    ln -s LuaJIT-${ver} LuaJIT
fi