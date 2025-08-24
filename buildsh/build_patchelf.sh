#!/bin/bash

name=patchelf
ver=0.18.0
srcpath=/home/lixq/src/${name}-${ver}-x86_64.tar.gz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

[[ -d "$DESTDIR"/usr ]] || mkdir -p "$DESTDIR"/usr
cd "$DESTDIR"/usr || exit 1
tar -xf $srcpath || exit 1
