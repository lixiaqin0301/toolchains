#!/bin/bash

name=libselinux
ver=3.9
srcpath=/home/lixq/src/${name}-${ver}.tar.gz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

export PATH="/home/lixq/toolchains/gcc/usr/bin:/home/lixq/toolchains/binutils/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export CC="/home/lixq/toolchains/gcc/usr/bin/gcc"
export CXX="/home/lixq/toolchains/gcc/usr/bin/g++"
export CFLAGS="--sysroot=$DESTDIR"
export CXXFLAGS="--sysroot=$DESTDIR"
export CPPFLAGS="--sysroot=$DESTDIR"
export LDFLAGS="-L$DESTDIR/usr/lib64 -Wl,-rpath-link,$DESTDIR/lib64 --sysroot=/home/lixq/toolset -Wl,-rpath,$DESTDIR/lib64 -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf $srcpath || exit 1
cd /home/lixq/src/selinux-${name}-${ver}/libsepol || exit 1
make -s -j"$(nproc)" || exit 1
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1
cd /home/lixq/src/selinux-${name}-${ver}/${name} || exit 1
make -s -j"$(nproc)" || exit 1
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1