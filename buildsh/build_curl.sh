#!/bin/bash

# https://curl.se/docs/http3.html

ver=8.15.0
DESTDIR=/home/lixq/toolchains/curl-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/curl-${ver}.tar.gz ]]; then
    echo "wget https://github.com/curl/curl/releases/download/curl-${ver//./_}/curl-${ver}.tar.gz"
    exit 1
fi

if [[ "$DESTDIR" == */curl-* ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" openssl nghttp3 ngtcp2 libpsl gsasl brotli zlib
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi
export CFLAGS="-pthread $CFLAGS"
export CXXFLAGS="-pthread $CXXFLAGS"
export LDFLAGS="-pthread $LDFLAGS"

cd /home/lixq/src || exit 1
rm -rf curl-${ver}
tar -xf /home/lixq/35share-rd/src/curl-${ver}.tar.gz
cd /home/lixq/src/curl-${ver} || exit 1
autoreconf -fi || exit 1
if [[ "$DESTDIR" == */curl-* ]]; then
    ./configure --prefix=/usr --with-openssl=/home/lixq/toolchains/openssl/usr --with-nghttp3=/home/lixq/toolchains/nghttp3/usr --with-ngtcp2=/home/lixq/toolchains/ngtcp2/usr --with-nghttp2=/home/lixq/toolchains/nghttp2/usr || exit 1
else
    ./configure --prefix=/usr || exit 1
fi
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */curl-* ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1

if [[ "$DESTDIR" == */curl-* ]]; then
    cd "$DESTDIR" || exit 1
    cd .. || exit 1
    rm curl
    ln -s curl-${ver} curl
fi
