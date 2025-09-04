#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=5.3
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="$DESTDIR/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export CPATH="/home/lixq/toolchains/boost_1_88_0/usr/include"
export LIBRARY_PATH="/home/lixq/toolchains/boost_1_88_0/usr/lib"
export LDFLAGS="-L$LIBRARY_PATH -Wl,-rpath-link,$LIBRARY_PATH"
export LD_RUN_PATH="$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
./configure "--prefix=$DESTDIR/usr" || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1

[[ -d $DESTDIR/usr/lib ]] || mkdir -p "$DESTDIR/usr/lib"
[[ -f $DESTDIR/usr/lib/libboost_system.so.1.88.0 ]] || cp /home/lixq/toolchains/boost_1_88_0/usr/lib/libboost_system.so.1.88.0 "$DESTDIR/usr/lib/libboost_system.so.1.88.0"
