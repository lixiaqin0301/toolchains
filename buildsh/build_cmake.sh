#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=$1
DESTDIR=$2
srcpath=/home/lixq/src/$name-$ver-linux-x86_64.tar.gz

[[ -n $ver ]] || exit 1
[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

[[ $DESTDIR == */$name ]] && rm -rf "$DESTDIR"
[[ -d $DESTDIR/usr ]] || mkdir -p "$DESTDIR/usr"
cd "$DESTDIR/usr" || exit 1
tar -xf "$srcpath" --strip-components=1 || exit 1
