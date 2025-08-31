#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=0.11.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-v$ver.linux.x86_64.tar.xz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

rm -rf /tmp/tb
mkdir /tmp/tb
cd /tmp/tb || exit 1
tar -xf "$srcpath" --strip-components=1 || exit 1

[[ -d $DESTDIR/usr/bin ]] || mkdir -p "$DESTDIR/usr/bin"
cp -a "$name" "$DESTDIR/usr/bin"
