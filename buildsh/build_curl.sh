#!/bin/bash

export CC=/home/lixq/toolchains/gcc/bin/gcc
export CXX=/home/lixq/toolchains/gcc/bin/g++
export CPP=/home/lixq/toolchains/gcc/bin/cpp
export LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/curl-7.81.0/thirdparty/openssl/lib:/home/lixq/toolchains/curl-7.81.0/thirdparty/nghttp3/lib:/home/lixq/toolchains/curl-7.81.0/thirdparty/ngtcp2/lib
export LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/curl-7.81.0/thirdparty/openssl/lib:/home/lixq/toolchains/curl-7.81.0/thirdparty/nghttp3/lib:/home/lixq/toolchains/curl-7.81.0/thirdparty/ngtcp2/lib"
export PKG_CONFIG_PATH=/home/lixq/toolchains/curl-7.81.0/thirdparty/openssl/lib/pkgconfig:/home/lixq/toolchains/curl-7.81.0/thirdparty/nghttp3/lib/pkgconfig:/home/lixq/toolchains/curl-7.81.0/thirdparty/ngtcp2/lib/pkgconfig

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src
rm -rf /home/lixq/toolchains/curl-7.81.0
mkdir -p /home/lixq/toolchains/curl-7.81.0/thirdparty
cd /home/lixq/toolchains

# openssl
if [[ ! -d /home/lixq/src/openssl-1.1.1l-quic ]]; then
    cd /home/lixq/src || exit 1
    if ! git clone --depth 1 -b OpenSSL_1_1_1l+quic https://github.com.cnpmjs.org/quictls/openssl openssl-1.1.1l-quic; then
        echo "Need /home/lixq/src/openssl-1.1.1l-quic (git clone --depth 1 -b OpenSSL_1_1_1l+quic https://github.com/quictls/openssl)"
        exit 1
    fi
fi
cd /home/lixq/src/openssl-1.1.1l-quic || exit 1
./config enable-tls1_3 --prefix=/home/lixq/toolchains/curl-7.81.0/thirdparty/openssl-1.1.1l-quic
make -j4
make install_sw
if [[ -d /home/lixq/toolchains/curl-7.81.0/thirdparty/openssl-1.1.1l-quic ]]; then
    cd /home/lixq/toolchains/curl-7.81.0/thirdparty || exit 1
    ln -s openssl-1.1.1l-quic openssl
fi

# nghttp3
if [[ ! -d /home/lixq/src/nghttp3 ]]; then
    cd /home/lixq/src || exit 1
    if ! git clone https://github.com.cnpmjs.org/ngtcp2/nghttp3; then
        echo "Need /home/lixq/src/nghttp3 (https://github.com/ngtcp2/nghttp3)"
        exit 1
    fi
fi
cd /home/lixq/src/nghttp3 || exit 1
autoreconf -i
./configure --prefix=/home/lixq/toolchains/curl-7.81.0/thirdparty/nghttp3 --enable-lib-only
make -j4 check
make install

# ngtcp2
if [[ ! -d /home/lixq/src/ngtcp2 ]]; then
    cd /home/lixq/src || exit 1
    if ! git clone https://github.com.cnpmjs.org/ngtcp2/ngtcp2; then
        echo "Need /home/lixq/src/ngtcp2 (https://github.com/ngtcp2/ngtcp2)"
        exit 1
    fi
fi
cd /home/lixq/src/ngtcp2 || exit 1
autoreconf -i
./configure --prefix=/home/lixq/toolchains/curl-7.81.0/thirdparty/ngtcp2
make -j4 check
make install

# curl
if [[ ! -f /home/lixq/src/curl-7.81.0.tar.bz2 ]]; then
    cd /home/lixq/src || exit 1
    if ! wget https://github.com.cnpmjs.org/curl/curl/releases/download/curl-7_81_0/curl-7.81.0.tar.bz2; then
        echo "Need /home/lixq/src/curl-7.81.0.tar.bz2 (https://github.com/curl/curl/releases/download/curl-7.81.0/curl-7.81.0.tar.bz2)"
        exit 1
    fi
fi
cd /home/lixq/src || exit 1
rm -rf curl-7.81.0
tar -xvf curl-7.81.0.tar.bz2
cd /home/lixq/src/curl-7.81.0 || exit 1
./configure --prefix=/home/lixq/toolchains/curl-7.81.0 --with-openssl --with-libssh2 --with-brotli --with-zstd --with-gssapi --with-libidn2 --enable-ldap --enable-ldaps --with-librtmp --with-nghttp2 --with-ngtcp2 || exit 1
make || exit 1
make install || exit 1
if [[ -d /home/lixq/toolchains/curl-7.81.0 ]]; then
    cd /home/lixq/toolchains || exit 1
    rm curl
    ln -s curl-7.81.0 curl
fi
