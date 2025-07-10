#!/bin/bash

ver=v24.3.0

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/glibc /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils /home/lixq/toolchains/Miniforge3

if [[ ! -f /home/lixq/35share-rd/src/node-${ver}.tar.gz ]]; then
    echo "wget https://nodejs.org/dist/${ver}/node-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/workspace-src ]] || mkdir /home/lixq/workspace-src
cd /home/lixq/workspace-src || exit 1
rm -rf node-${ver}
tar -xf /home/lixq/35share-rd/src/node-${ver}.tar.gz
cd node-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/node-${ver} --shared || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/node-${ver}
make install || exit 1
cd /home/lixq/toolchains/node-${ver}/lib || exit 1
ln -s libnode.so.* libnode.so
cd /home/lixq/toolchains || exit 1
rm -f node
ln -s node-${ver} node
