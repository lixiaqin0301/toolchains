#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=1.0.8
DESTDIR=$1
srcpath=/home/lixq/src/${name}-${ver}.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
make -s "-j$(nproc)" -f Makefile-libbz2_so
make -s "-j$(nproc)" install "PREFIX=$DESTDIR/usr"
cp -a libbz2.so.$ver "$DESTDIR/usr/lib/libbz2.so.$ver"
cd "$DESTDIR/usr/lib/"
ln -sf libbz2.so.$ver libbz2.so
ln -sf libbz2.so.$ver libbz2.so.${ver%.*.*}
ln -sf libbz2.so.$ver libbz2.so.${ver%.*}
