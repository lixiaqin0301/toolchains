#!/bin/bash

ver=1.6.1
DESTDIR=/home/lixq/toolchains/libbpf-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/src/libbpf-${ver}.tar.gz ]]; then
    echo "wget https://github.com/libbpf/libbpf/archive/refs/tags/v${ver}.tar.gz -O libbpf-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" gcc

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf libbpf-${ver}
tar -xf /home/lixq/src/libbpf-${ver}.tar.gz
cd /home/lixq/src/libbpf-${ver}/src || exit 1
make -s -j"$(nproc)" || exit 1
rm -rf "${DESTDIR}"
make -s -j"$(nproc)" install DESTDIR="${DESTDIR}" || exit 1

if [[ "$(basename "${DESTDIR}")" == libbpf-${ver} ]]; then
    cd "${DESTDIR}" || exit 1
    cd .. || exit 1
    rm -f libbpf
    ln -s libbpf-${ver} libbpf
fi
