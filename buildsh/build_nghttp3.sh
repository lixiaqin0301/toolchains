#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=1.12.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig"
export CPATH="$DESTDIR/usr/include"
export LIBRARY_PATH="$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
autoreconf -fi || exit 1
./configure "--prefix=$DESTDIR/usr" || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1
