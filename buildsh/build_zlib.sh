#!/bin/bash

ver=1.3.1

export PATH="/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/binutils/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export CC="/home/lixq/toolchains/gcc/bin/gcc"
export CXX="/home/lixq/toolchains/gcc/bin/g++"
export CCAS="/home/lixq/toolchains/gcc/bin/gcc"
export CPP="/home/lixq/toolchains/gcc/bin/cpp"
export CFLAGS="-I/home/lixq/toolchains/binutils/include"
export CXXFLAGS="-I/home/lixq/toolchains/binutils/include"
export LDFLAGS="-L/home/lixq/toolchains/gcc/lib64 -L/home/lixq/toolchains/binutils/lib -Wl,-rpath=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/binutils/lib"

if [[ ! -f /home/lixq/35share-rd/src/zlib-${ver}.tar.xz ]]; then
    echo "wget https://github.com/madler/zlib/releases/download/v${ver}/zlib-${ver}.tar.xz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf zlib-${ver}
tar -xf /home/lixq/35share-rd/src/zlib-${ver}.tar.xz
cd zlib-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/zlib-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/zlib-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/zlib-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f zlib
    ln -s zlib-${ver} zlib
fi
