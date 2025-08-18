#!/bin/bash

ver=1.0.8
DESTDIR=/home/lixq/toolchains/bzip2-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/bzip2-${ver}.tar.gz ]]; then
    echo "wget https://sourceware.org/pub/bzip2/bzip2-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" gcc glibc

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf bzip2-${ver}
tar -xf /home/lixq/35share-rd/src/bzip2-${ver}.tar.gz
cd /home/lixq/src/bzip2-${ver} || exit 1
sed -i -e "s;CFLAGS=;CFLAGS=$CFLAGS ;" -e "s;LDFLAGS=;LDFLAGS=$LDFLAGS;" Makefile
sed -i -e "/CC=/a LDFLAGS=$LDFLAGS" -e "s;LDFLAGS=;LDFLAGS=$LDFLAGS;" -e "s;\$(CC) \$(CFLAGS) -o;\$(CC) \$(CFLAGS) \$(LDFLAGS) -o;" -e "s;\$(CC) -shared;\$(CC) \$(LDFLAGS) -shared;" Makefile-libbz2_so
make -s -j"$(nproc)" -f Makefile-libbz2_so || exit 1
rm -rf "${DESTDIR}"
make -s -j"$(nproc)" install PREFIX="${DESTDIR}/usr" || exit 1
cp libbz2.so.${ver} "${DESTDIR}/usr/lib/libbz2.so.${ver}"
cd "${DESTDIR}/usr/lib/" || exit 1
ln -sf libbz2.so.${ver} libbz2.so
ln -sf libbz2.so.${ver} libbz2.so.${ver%.*.*}
ln -sf libbz2.so.${ver} libbz2.so.${ver%.*}

if [[ "$(basename "${DESTDIR}")" == bzip2-${ver} ]]; then
    cd "${DESTDIR}" || exit 1
    cd .. || exit 1
    rm -f bzip2
    ln -s bzip2-${ver} bzip2
fi
