#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=3.9
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LDFLAGS="-static-libgcc -static-libstdc++"
export CFLAGS="--sysroot=$DESTDIR"
export CXXFLAGS="--sysroot=$DESTDIR"
export CPPFLAGS="--sysroot=$DESTDIR"
export LDFLAGS="-L$DESTDIR/usr/lib64 -Wl,-rpath-link,$DESTDIR/lib64 --sysroot=$DESTDIR -Wl,-rpath,$DESTDIR/lib64 -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "/home/lixq/src/selinux-$name-$ver/libsepol" || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install "DESTDIR=$DESTDIR" || exit 1
cd "/home/lixq/src/selinux-$name-$ver/$name" || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install "DESTDIR=$DESTDIR" || exit 1
