#!/bin/bash

ver=2.7.0
DESTDIR=/home/lixq/toolchains/netperf-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/netperf-${ver}.tar.gz ]]; then
    echo "wget https://github.com/HewlettPackard/netperf/archive/refs/tags/netperf-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf netperf-netperf-${ver}
tar -xf /home/lixq/35share-rd/src/netperf-${ver}.tar.gz
cd /home/lixq/src/netperf-netperf-${ver} || exit 1
./configure || exit 1
make -s -j"$(nproc)" || exit 1
rm -rf "${DESTDIR}"
make -s -j"$(nproc)" install DESTDIR="${DESTDIR}" || exit 1

if [[ "$(basename "${DESTDIR}")" == netperf-${ver} ]]; then
    cd "${DESTDIR}" || exit 1
    cd .. || exit 1
    rm -f netperf
    ln -s netperf-${ver} netperf
fi
