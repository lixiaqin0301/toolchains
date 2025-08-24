#!/bin/bash
name=shellcheck
ver=0.11.0
srcpath=/home/lixq/src/${name}-v${ver}.linux.x86_64.tar.xz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

rm -rf /tmp/tb
mkdir /tmp/tb
cd /tmp/tb || exit 1
tar -xf "$srcpath" --strip-components=1 || exit 1

[[ -d "$DESTDIR"/usr/bin ]] || mkdir -p "$DESTDIR"/usr/bin
cp -a ${name} "$DESTDIR"/usr/bin
