#!/bin/bash

name=keyutils
ver=1.6.3
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/src/${name}-${ver}.tar.gz ]]; then
    echo "wget https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/snapshot/${name}-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf /home/lixq/src/${name}-${ver}.tar.gz
cd ${name}-${ver} || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="${DESTDIR}" PREFIX=/usr || exit 1
