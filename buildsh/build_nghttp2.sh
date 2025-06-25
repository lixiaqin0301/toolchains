#!/bin/bash

ver=1.66.0

if [[ ! -f /home/lixq/35share-rd/src/nghttp2-${ver}.tar.gz ]]; then
    echo "wget https://github.com/nghttp2/nghttp2/releases/download/v${ver}/nghttp2-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils /home/lixq/toolchains/openssl /home/lixq/toolchains/nghttp3 /home/lixq/toolchains/ngtcp2

cd /home/lixq/src || exit 1
rm -rf nghttp2-${ver}
tar -xf /home/lixq/35share-rd/src/nghttp2-${ver}.tar.gz
cd /home/lixq/src/nghttp2-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/nghttp2-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/nghttp2-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/nghttp2-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm nghttp2
    ln -s nghttp2-${ver} nghttp2
fi
