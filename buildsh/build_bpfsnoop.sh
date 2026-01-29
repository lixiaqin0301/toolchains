#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=0.5.4
DESTDIR=$1
srcpath=/home/lixq/src/$name-v$ver-linux-amd64.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

[[ -d $DESTDIR/usr/bin ]] || mkdir -p "$DESTDIR/usr/bin"
cd "$DESTDIR/usr/bin" || exit 1
tar -xf "$srcpath" || exit 1
rm -f ./*.sha256sum
