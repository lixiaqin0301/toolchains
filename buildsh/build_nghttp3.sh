#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=1.16.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/lib64/pkgconfig:$DESTDIR/usr/lib64/pkgconfig:$DESTDIR/lib/pkgconfig:$DESTDIR/usr/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="$DESTDIR"
export CPATH="$DESTDIR/usr/include"
export LIBRARY_PATH="$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver/lib"
git clone https://github.com/ngtcp2/sfparse
cd "/home/lixq/src/$name-$ver"
autoreconf -fi
./configure --prefix=/usr
make -s "-j$(nproc)"
make -s "-j$(nproc)" install DESTDIR="$DESTDIR"
