#!/bin/bash

ver=1.10.1

if [[ ! -f /home/lixq/35share-rd/src/nghttp3-${ver}.tar.gz ]]; then
    echo "wget https://github.com/ngtcp2/nghttp3/releases/download/v${ver}/nghttp3-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils

cd /home/lixq/src || exit 1
rm -rfv nghttp3-${ver}
tar -xf /home/lixq/35share-rd/src/nghttp3-${ver}.tar.gz
cd /home/lixq/src/nghttp3-${ver} || exit 1
autoreconf -fi || exit 1
./configure --prefix=/home/lixq/toolchains/nghttp3-${ver} --enable-lib-only || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/nghttp3-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/nghttp3-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm nghttp3
    ln -s nghttp3-${ver} nghttp3
fi
