#!/bin/bash

name=Linux-PAM
ver=1.7.1
srcpath=/home/lixq/src/${name}-${ver}.tar.xz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf $srcpath || exit 1
cd ${name}-${ver} || exit 1
mkdir build
meson setup --prefix="$DESTDIR/usr" build || exit 1
meson compile -C build || exit 1
meson install -C build || exit 1
