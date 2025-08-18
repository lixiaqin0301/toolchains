#!/bin/bash

ver=0.193
DESTDIR=/home/lixq/toolchains/elfutils-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/elfutils-${ver}.tar.bz2 ]]; then
    echo "wget https://sourceware.org/elfutils/ftp/${ver}/elfutils-${ver}.tar.bz2"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" gcc glibc openssl nghttp3 ngtcp2 nghttp2 libpsl gsasl brotli zlib curl bzip2 json-c xz elfutils

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf elfutils-${ver}
tar -xf /home/lixq/35share-rd/src/elfutils-${ver}.tar.bz2
cd /home/lixq/src/elfutils-${ver} || exit 1
./configure --enable-libdebuginfod || exit 1
make -s -j"$(nproc)" || exit 1
rm -rf "${DESTDIR}"
make -s -j"$(nproc)" install DESTDIR="${DESTDIR}" || exit 1

if [[ "$(basename "${DESTDIR}")" == elfutils-${ver} ]]; then
    cd "${DESTDIR}" || exit 1
    cd .. || exit 1
    rm -f elfutils
    ln -s elfutils-${ver} elfutils
fi
