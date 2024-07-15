#!/bin/bash

export PATH=/home/lixq/toolchains/cmake/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/lixq/toolchains/llvm/bin
. /opt/rh/devtoolset-11/enable

ver=2.38

if [[ ! -f /home/lixq/35share-rd/src/rtags-${ver}.tar.gz ]]; then
    echo "git clone --recursive https://github.com/Andersbakken/rtags.git rtags-${ver}"
    echo "tar -cjvf rtags-${ver}.tar.gz rtags-${ver}"
    exit 1
fi

cd /home/lixq/src || exit 1
rm -rf rtags-${ver}
tar -xf /home/lixq/35share-rd/src/rtags-${ver}.tar.gz
cd /home/lixq/src/rtags-${ver} || exit 1
mkdir build
cd build || exit 1
cmake -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/rtags-${ver} .. || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/rtags-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/rtags-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f rtags
    ln -s rtags-${ver} rtags
fi
