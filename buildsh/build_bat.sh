#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=0.26.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-v$ver-x86_64-unknown-linux-musl.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

rm -rf /tmp/tb
mkdir /tmp/tb
cd /tmp/tb || exit 1
tar -xf "$srcpath" --strip-components=1 || exit 1
[[ -d $DESTDIR/usr/bin ]] || mkdir -p "$DESTDIR/usr/bin"
cp -a "$name" "$DESTDIR/usr/bin"
[[ -d $DESTDIR/usr/man/man1 ]] || mkdir -p "$DESTDIR/usr/man/man1"
cp -a "$name.1" "$DESTDIR/usr/man/man1"
