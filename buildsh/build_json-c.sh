#!/bin/bash

ver=0.18-20240915
DESTDIR=/home/lixq/toolchains/json-c-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/src/json-c-${ver}.tar.gz ]]; then
    echo "wget https://github.com/json-c/json-c/archive/refs/tags/json-c-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" gcc glibc
export PATH="/home/lixq/toolchains/cmake/bin:$PATH"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf json-c-json-c-${ver}
tar -xf /home/lixq/src/json-c-${ver}.tar.gz
cd /home/lixq/src/json-c-json-c-${ver} || exit 1
mkdir json-c-build
cd /home/lixq/src/json-c-json-c-${ver}/json-c-build || exit 1
cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 .. || exit 1
make -s -j"$(nproc)" || exit 1
rm -rf "${DESTDIR}"
make -s -j"$(nproc)" install DESTDIR="${DESTDIR}" || exit 1

if [[ "$(basename "${DESTDIR}")" == json-c-${ver} ]]; then
    cd "${DESTDIR}" || exit 1
    cd .. || exit 1
    rm -f json-c
    ln -s json-c-${ver} json-c
fi
