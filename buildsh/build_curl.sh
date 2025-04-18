#!/bin/bash

# https://curl.se/docs/http3.html

ver=8.13.0
nghttp2ver=1.65.0
nghttp3ver=1.8.0
ngtcp2ver=1.11.0

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src

cd /home/lixq/src || exit 1
rm -rfv nghttp2-${nghttp2ver}
tar -xf /home/lixq/35share-rd/src/nghttp2-${nghttp2ver}.tar.xz
cd /home/lixq/src/nghttp2-${nghttp2ver} || exit 1
[[ -d /home/lixq/toolchains/curl/libs/nghttp2 ]] || mkdir -p /home/lixq/toolchains/curl/libs/nghttp2
./configure --prefix=/home/lixq/toolchains/curl/libs/nghttp2 --enable-lib-only || exit 1
make || exit 1
make install || exit 1

cd /home/lixq/src || exit 1
rm -rfv openssl
tar -xf /home/lixq/35share-rd/src/openssl.tar.xz
cd /home/lixq/src/openssl || exit 1
[[ -d /home/lixq/toolchains/curl/libs/openssl ]] || mkdir -p /home/lixq/toolchains/curl/libs/openssl
./config enable-tls1_3 --prefix=/home/lixq/toolchains/curl/libs/openssl || exit 1
make || exit 1
make install || exit 1

cd /home/lixq/src || exit 1
rm -rfv nghttp3-${nghttp3ver}
tar -xf /home/lixq/35share-rd/src/nghttp3-${nghttp3ver}.tar.xz
cd /home/lixq/src/nghttp3-${nghttp3ver} || exit 1
autoreconf -fi || exit 1
[[ -d /home/lixq/toolchains/curl/libs/nghttp3 ]] || mkdir -p /home/lixq/toolchains/curl/libs/nghttp3
./configure --prefix=/home/lixq/toolchains/curl/libs/nghttp3 --enable-lib-only || exit 1
make || exit 1
make install || exit 1

cd /home/lixq/src || exit 1
rm -rfv ngtcp2-${ngtcp2ver}
tar -xf /home/lixq/35share-rd/src/ngtcp2-${ngtcp2ver}.tar.xz
cd /home/lixq/src/ngtcp2-${ngtcp2ver} || exit 1
autoreconf -fi || exit 1
[[ -d /home/lixq/toolchains/curl/libs/ngtcp2 ]] || mkdir -p /home/lixq/toolchains/curl/libs/ngtcp2
./configure PKG_CONFIG_PATH=/home/lixq/toolchains/curl/libs/openssl/lib64/pkgconfig:/home/lixq/toolchains/curl/libs/nghttp3/lib/pkgconfig LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/curl/libs/openssl/lib64" --prefix=/home/lixq/toolchains/curl/libs/ngtcp2 --enable-lib-only || exit 1
make || exit 1
make install || exit 1

cd /home/lixq/src || exit 1
rm -rfv curl-${ver}
tar -xf /home/lixq/35share-rd/src/curl-${ver}.tar.xz
cd /home/lixq/src/curl-${ver} || exit 1
autoreconf -fi || exit 1
LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/curl/libs/openssl/lib64" ./configure --prefix=/home/lixq/toolchains/curl --with-nghttp2=/home/lixq/toolchains/curl/libs/nghttp2 --with-openssl=/home/lixq/toolchains/curl/libs/openssl --with-nghttp3=/home/lixq/toolchains/curl/libs/nghttp3 --with-ngtcp2=/home/lixq/toolchains/curl/libs/ngtcp2 || exit 1
make || exit 1
make install || exit 1
