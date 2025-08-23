#!/bin/bash

name=cmake
ver=4.1.0
srcpath=/home/lixq/src/${name}-${ver}-linux-x86_64.tar.gz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

[[ -d "$DESTDIR"/usr ]] || mkdir -p "$DESTDIR"/usr
cd "$DESTDIR"/usr || exit 1
tar -xf $srcpath --strip-components=1 || exit 1
