#!/bin/bash

ver=1.14.0

if [[ ! -f /home/lixq/35share-rd/src/ngtcp2-${ver}.tar.gz ]]; then
    echo "wget https://github.com/ngtcp2/ngtcp2/releases/download/v${ver}/ngtcp2-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils /home/lixq/toolchains/openssl /home/lixq/toolchains/nghttp3

cd /home/lixq/src || exit 1
rm -rf ngtcp2-${ver}
tar -xf /home/lixq/35share-rd/src/ngtcp2-${ver}.tar.gz
cd /home/lixq/src/ngtcp2-${ver} || exit 1
autoreconf -fi || exit 1
./configure --prefix=/home/lixq/toolchains/ngtcp2-${ver} --with-openssl || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/ngtcp2-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/ngtcp2-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm ngtcp2
    ln -s ngtcp2-${ver} ngtcp2
fi
