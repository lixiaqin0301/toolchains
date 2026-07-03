#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=0.195
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.bz2
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH="/home/lixq/toolchains/gcc/usr/bin:/home/lixq/toolchains/make/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/lib64/pkgconfig:$DESTDIR/usr/lib64/pkgconfig:$DESTDIR/usr/lib/pkgconfig"
export LD_RUN_PATH="$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"
export CFLAGS="-Wno-error"
export LDFLAGS="-L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -L$DESTDIR/lib -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
./configure "--prefix=$DESTDIR/usr" --enable-libdebuginfod
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
