#!/bin/bash

ver=2.6.4
DESTDIR=/home/lixq/toolchains/flex-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/src/flex-${ver}.tar.gz ]]; then
    echo "wget https://github.com/westes/flex/releases/download/v${ver}/flex-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf flex-${ver}
tar -xf /home/lixq/src/flex-${ver}.tar.gz
cd /home/lixq/src/flex-${ver} || exit 1
./configure || exit 1
make -s -j"$(nproc)" || exit 1
rm -rf "${DESTDIR}"
make -s -j"$(nproc)" install DESTDIR="${DESTDIR}" || exit 1

if [[ "$(basename "${DESTDIR}")" == flex-${ver} ]]; then
    cd "${DESTDIR}" || exit 1
    cd .. || exit 1
    rm -f flex
    ln -s flex-${ver} flex
fi
