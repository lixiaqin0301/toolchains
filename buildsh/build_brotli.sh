#!/bin/bash

ver=1.1.0

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils
export PATH="$PATH:/home/lixq/toolchains/cmake/bin"
if [[ ! -f /home/lixq/35share-rd/src/brotli-${ver}.tar.gz ]]; then
    echo "wget https://github.com/google/brotli/archive/refs/tags/v${ver}.tar.gz -O brotli-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf brotli-${ver}
tar -xf /home/lixq/35share-rd/src/brotli-${ver}.tar.gz
mkdir brotli-${ver}/out
cd /home/lixq/src/brotli-${ver}/out || exit 1
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/brotli-${ver} .. || exit 1
rm -rf /home/lixq/toolchains/brotli-${ver}
cmake --build . --config Release --target install || exit 1
if [[ -d /home/lixq/toolchains/brotli-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f brotli
    ln -s brotli-${ver} brotli
fi
