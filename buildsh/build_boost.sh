#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=1_89_0
DESTDIR=$1
srcpath=/home/lixq/src/${name}_$ver.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/patchelf/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "${name}_$ver"
tar -xf "$srcpath" || exit 1
cd "${name}_$ver" || exit 1
./bootstrap.sh "--prefix=$DESTDIR/usr" || exit 1
patchelf --set-rpath /home/lixq/toolchains/gcc/usr/lib64:lib64 ./b2 || exit 1
./b2 "linkflags=$LDFLAGS" -s "-j$(nproc)" || exit 1
./b2 "linkflags=$LDFLAGS" -s "-j$(nproc)" install || exit 1
