#!/bin/bash

# https://curl.se/docs/http3.html

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=8.15.0
DESTDIR=$1
srcpath=/home/lixq/src/${name}-${ver}.tar.gz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig"
export CFLAGS="-isystem $DESTDIR/usr/include -pthread"
export CXXFLAGS="-isystem $DESTDIR/usr/include -pthread"
export CPPFLAGS="-isystem $DESTDIR/usr/include"
export LDFLAGS="-pthread -L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -L$DESTDIR/lib -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib -static-libgcc -static-libstdc++ -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
autoreconf -fi || exit 1
./configure "--prefix=$DESTDIR/usr" --with-openssl --with-nghttp3 --with-ngtcp2 --with-nghttp2 --with-libssh2 --with-zstd --with-gssapi --with-libidn2 --with-ldap --enable-httpsrr --enable-ssls-export || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1
