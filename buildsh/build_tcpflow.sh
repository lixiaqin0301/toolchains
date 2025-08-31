#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=1.6.1
DESTDIR=$1
srcpath=/home/lixq/src/${name}-${ver}.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/patchelf/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export CFLAGS="-isystem /home/lixq/toolchains/boost/usr/include"
export CXXFLAGS="-isystem /home/lixq/toolchains/boost/usr/include"
export CPPFLAGS="-isystem /home/lixq/toolchains/boost/usr/include"
export LDFLAGS="-L/home/lixq/toolchains/boost/usr/lib -Wl,-rpath-link,/home/lixq/toolchains/boost/usr/lib -static-libgcc -static-libstdc++"

cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
./configure "--prefix=$DESTDIR/usr" || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1
