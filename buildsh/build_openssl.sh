#!/bin/bash

ver=3.5.0

if [[ ! -f /home/lixq/35share-rd/src/openssl-${ver}.tar.gz ]]; then
    echo "wget https://github.com/openssl/openssl/releases/download/openssl-${ver}/openssl-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils /home/lixq/toolchains/openssl

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf openssl-${ver}
tar -xf /home/lixq/35share-rd/src/openssl-${ver}.tar.gz
cd /home/lixq/src/openssl-${ver} || exit 1
./config --prefix=/home/lixq/toolchains/openssl-${ver} --libdir=lib || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/openssl-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/openssl-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm  -rf openssl
    ln -s openssl-${ver} openssl
fi
