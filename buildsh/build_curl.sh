#!/bin/bash

# https://curl.se/docs/http3.html

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=8.15.0
DESTDIR=$1
srcpath=/home/lixq/src/${name}-${ver}.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig"
export LDFLAGS="-L/home/lixq/toolchains/gcc/usr/lib64 -static-libgcc -static-libstdc++ -Wl,-rpath,$DESTDIR/usr/lib"
if [[ -f $DESTDIR/lib64/ld-linux-x86-64.so.2 ]]; then
    export CPPFLAGS="-I$DESTDIR/include --sysroot=$DESTDIR"
    export LDFLAGS="-L$DESTDIR/usr/lib64 -Wl,-rpath-link,$DESTDIR/lib64 --sysroot=$DESTDIR -Wl,-rpath,$DESTDIR/lib64 -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"
fi

cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
autoreconf -fi || exit 1
if [[ $DESTDIR == */$name ]]; then
    ./configure "--prefix=$DESTDIR/usr" --with-openssl --with-nghttp3 --with-ngtcp2 --with-nghttp2 --with-libssh2 --with-zstd --with-gssapi --with-libidn2 --with-ldap --enable-httpsrr --enable-ssls-export || exit 1
else
    ./configure "--prefix=$DESTDIR/usr" --with-openssl || exit 1
fi
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1
