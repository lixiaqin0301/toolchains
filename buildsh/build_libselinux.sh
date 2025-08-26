#!/bin/bash

name=libselinux
ver=3.9
srcpath=/home/lixq/src/${name}-${ver}.tar.gz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf $srcpath || exit 1
cd /home/lixq/src/selinux-${name}-${ver}/libsepol || exit 1
make -s -j"$(nproc)" || exit 1
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1
cd /home/lixq/src/selinux-${name}-${ver}/${name} || exit 1
make -s -j"$(nproc)" || exit 1
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1