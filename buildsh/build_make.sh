#!/bin/bash

ver=4.4.1

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils

if [[ ! -f /home/lixq/35share-rd/src/make-${ver}.tar.gz ]]; then
    echo "wget https://ftp.gnu.org/gnu/make/make-${ver}.tar.gz -O make-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf make-${ver}
tar -xf /home/lixq/35share-rd/src/make-${ver}.tar.gz
cd make-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/make-${ver} || exit 1
make -j"$(nproc)" || exit 1
rm -rf /home/lixq/toolchains/make-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/make-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f make
    ln -s make-${ver} make
    cd /home/lixq/toolchains/make-${ver}/bin || exit 1
    ln -s make gmake
fi
