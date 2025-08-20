#!/bin/bash

# https://curl.se/docs/http3.html

name=curl
ver=8.15.0
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/${name}-${ver}.tar.gz ]]; then
    echo "wget https://github.com/curl/curl/releases/download/${name}-${ver//./_}/${name}-${ver}.tar.gz"
    exit 1
fi

if [[ "$DESTDIR" == */${name} ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" libpsl gsasl brotli zlib ${name}
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi
export CPPFLAGS="$CFLAGS"
export CFLAGS="-pthread"
export CXXFLAGS="-pthread"
export LDFLAGS="-pthread $LDFLAGS"

cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf /home/lixq/35share-rd/src/${name}-${ver}.tar.gz
cd /home/lixq/src/${name}-${ver} || exit 1
autoreconf -fi || exit 1
if [[ "$DESTDIR" == */${name} ]]; then
    ./configure --prefix="$DESTDIR/usr" --with-openssl=/home/lixq/toolchains/openssl/usr --with-nghttp3=/home/lixq/toolchains/nghttp3/usr --with-ngtcp2=/home/lixq/toolchains/ngtcp2/usr --with-nghttp2=/home/lixq/toolchains/nghttp2/usr || exit 1
else
    ./configure --prefix="$DESTDIR/usr" --with-openssl --with-nghttp3 --with-ngtcp2 --with-nghttp2 || exit 1
fi
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install || exit 1
