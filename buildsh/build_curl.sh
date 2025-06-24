#!/bin/bash

# https://curl.se/docs/http3.html

ver=8.14.1

if [[ ! -f /home/lixq/35share-rd/src/curl-${ver}.tar.gz ]]; then
    echo "wget https://github.com/curl/curl/releases/download/curl-${ver//./_}/curl-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" \
    /home/lixq/toolchains/gcc \
    /home/lixq/toolchains/binutils \
    /home/lixq/toolchains/openssl \
    /home/lixq/toolchains/nghttp3 \
    /home/lixq/toolchains/ngtcp2 \
    /home/lixq/toolchains/nghttp2 \
    /home/lixq/toolchains/libpsl \
    /home/lixq/toolchains/libgsasl \
    /home/lixq/toolchains/brotli \
    /home/lixq/toolchains/zlib
export CFLAGS="-pthread $CFLAGS"
export CXXFLAGS="-pthread $CXXFLAGS"
export LDFLAGS="-pthread $LDFLAGS"
cd /home/lixq/src || exit 1
rm -rf curl-${ver}
tar -xf /home/lixq/35share-rd/src/curl-${ver}.tar.gz
cd /home/lixq/src/curl-${ver} || exit 1
autoreconf -fi || exit 1
./configure --prefix=/home/lixq/toolchains/curl-${ver} --with-openssl=/home/lixq/toolchains/openssl --with-nghttp3=/home/lixq/toolchains/nghttp3 --with-ngtcp2=/home/lixq/toolchains/ngtcp2 --with-nghttp2=/home/lixq/toolchains/nghttp2 || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/curl-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/curl-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm curl
    ln -s curl-${ver} curl
fi
