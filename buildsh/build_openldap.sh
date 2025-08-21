#!/bin/bash

name=openldap
ver=2.6.10
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/${name}-${ver}.tgz ]]; then
    echo "wget https://mirror-hk.koddos.net/OpenLDAP/openldap-release/${name}-${ver}.tgz"
    exit 1
fi

if [[ "$DESTDIR" == */${name} ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" openssl
    export CPPFLAGS="-isystem /home/lixq/toolchains/openssl/usr/include"
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf /home/lixq/35share-rd/src/${name}-${ver}.tgz
cd ${name}-${ver} || exit 1
./configure --prefix="$DESTDIR/usr" --with-tls=openssl || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install || exit 1
