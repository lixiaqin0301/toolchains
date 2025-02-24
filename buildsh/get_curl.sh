#!/bin/bash

rm -rf openssl openssl.tar.xz
git clone --depth 1 -b openssl-3.1.4+quic https://github.com/quictls/openssl
tar -cJf openssl.tar.xz openssl
rm -rf openssl

wget https://github.com/ngtcp2/nghttp3/releases/download/v1.8.0/nghttp3-1.8.0.tar.xz
wget https://github.com/ngtcp2/ngtcp2/releases/download/v1.11.0/ngtcp2-1.11.0.tar.xz
wget https://github.com/nghttp2/nghttp2/releases/download/v1.64.0/nghttp2-1.64.0.tar.xz
wget https://github.com/curl/curl/releases/download/curl-8_12_1/curl-8.12.1.tar.xz
