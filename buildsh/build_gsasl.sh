#!/bin/bash

ver=2.2.2

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils

if [[ ! -f /home/lixq/35share-rd/src/gsasl-${ver}.tar.gz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/gsasl/gsasl-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf gsasl-${ver}
tar -xf /home/lixq/35share-rd/src/gsasl-${ver}.tar.gz
mkdir gsasl-${ver}/build
cd /home/lixq/src/gsasl-${ver}/build || exit 1
../configure --prefix=/home/lixq/toolchains/gsasl-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/gsasl-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/gsasl-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f gsasl
    ln -s gsasl-${ver} gsasl
fi
