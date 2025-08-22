#!/bin/bash
name=bat
ver=0.25.0
srcpath=/home/lixq/src/${name}-v${ver}-x86_64-unknown-linux-gnu.tar.gz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

rm -rf /tmp/tb
mkdir /tmp/tb
cd /tmp/tb || exit 1
tar -xf "$srcpath" --strip-components=1 || exit 1

[[ -d "$DESTDIR"/usr/bin ]] || mkdir -p "$DESTDIR"/usr/bin
cp -a bat "$DESTDIR"/usr/bin
[[ -d "$DESTDIR"/usr/man/man1 ]] || mkdir -p "$DESTDIR"/usr/man/man1
cp -a bat.1 "$DESTDIR"/usr/man/man1
