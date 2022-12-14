#!/bin/bash

ver=2.38

export PATH=/home/lixq/toolchains/cmake/bin:/home/lixq/toolchains/llvm/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/src/rtags-${ver}.tar.bz2 ]]; then
    echo "wget https://github.com/Andersbakken/rtags/releases/download/v${ver}/rtags-${ver}.tar.bz2 -O /home/lixq/src/rtags-${ver}.tar.bz2"
    exit 1
fi

cd /home/lixq/src || exit 1
rm -rf rtags-${ver}
tar -xvf rtags-${ver}.tar.bz2
mkdir rtags-${ver}/build
cd rtags-${ver}/build || exit 1

cmake -DCMAKE_LIBRARY_PATH=/home/lixq/toolchains/llvm/lib \
      -DCMAKE_INSTALL_RPATH=/home/lixq/toolchains/llvm/lib \
      -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/rtags-${ver} \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
      .. || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/rtags-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/rtags-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f rtags
    ln -s rtags-${ver} rtags
fi
