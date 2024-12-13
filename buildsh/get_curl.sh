#!/bin/bash

rm -rf openssl openssl.tar.xz
git clone --depth 1 -b openssl-3.1.4+quic https://github.com/quictls/openssl
tar -cJf openssl.tar.xz openssl
rm -rf openssl

rm -rf nghttp3 nghttp3.tar.xz
git clone -b v1.1.0 https://github.com/ngtcp2/nghttp3
cd nghttp3 || exit 1
git submodule update --init
cd .. || exit 1
tar -cJf nghttp3.tar.xz nghttp3
rm -rf nghttp3

rm -rf ngtcp2 ngtcp2.tar.xz
git clone -b v1.2.0 https://github.com/ngtcp2/ngtcp2
tar -cJf ngtcp2.tar.xz ngtcp2
rm -rf ngtcp2

wget https://github.com/nghttp2/nghttp2/releases/download/v1.64.0/nghttp2-1.64.0.tar.xz
wget https://github.com/curl/curl/releases/download/curl-8_11_1/curl-8.11.1.tar.xz
