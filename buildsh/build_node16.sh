#!/bin/bash

ver=v16.20.2

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc /home/lixq/toolchains/binutils
export PATH="$PATH:/home/lixq/toolchains/Bear/bin"
export CFLAGS="-g $CFLAGS"
export CXXFLAGS="-g $CXXFLAGS"
if [[ ! -f /home/lixq/src/node-${ver}.tar.gz ]]; then
    echo "wget https://nodejs.org/dist/${ver}/node-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/workspace-vscode ]] || mkdir /home/lixq/workspace-vscode
cd /home/lixq/workspace-vscode || exit 1
rm -rf node-${ver}
tar -xf /home/lixq/src/node-${ver}.tar.gz
cd /home/lixq/workspace-vscode/node-${ver} || exit 1
sed -i '/#include <unordered_set>/a #include <cstdint>' src/inspector/worker_inspector.h
./configure --prefix=/home/lixq/toolchains/node16-${ver} --shared || exit 1
bear -- make || exit 1
rm -rf /home/lixq/toolchains/node16-${ver}
make install || exit 1
cd /home/lixq/toolchains/node16-${ver}/lib || exit 1
ln -s libnode.so.* libnode.so
cp /home/lixq/workspace-vscode/node-${ver}/deps/v8/include/v8-inspector*.h /home/lixq/toolchains/node16-${ver}/include/node/
