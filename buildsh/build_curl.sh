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
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" openssl nghttp3 ngtcp2 nghttp2 zlib keyutils krb5 brotli zstd libpsl gsasl ${name}
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
    ./configure --prefix="$DESTDIR/usr" \
                --with-openssl=/home/lixq/toolchains/openssl/usr \
                --with-nghttp3=/home/lixq/toolchains/nghttp3/usr \
                --with-ngtcp2=/home/lixq/toolchains/ngtcp2/usr \
                --with-nghttp2=/home/lixq/toolchains/nghttp2/usr \
                --with-libssh2=/home/lixq/toolchains/libssh2/usr \
                --with-gssapi=/home/lixq/toolchains/krb5/usr \
                --with-libidn2=/home/lixq/toolchains/libidn2/usr \
                --with-ldap=/home/lixq/toolchains/openldap/usr \
                --enable-httpsrr \
                --enable-ssls-export \
                || exit 1
else
    ./configure --prefix="$DESTDIR/usr" --with-openssl --with-nghttp3 --with-ngtcp2 --with-nghttp2 --with-libssh2 --with-zstd --with-gssapi --with-libidn2 --with-ldap --enable-httpsrr --enable-ssls-export || exit 1
fi
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install || exit 1
