#!/bin/bash

ver=2.37.2

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src

if [[ ! -f /home/lixq/src/git-${ver}.tar.gz ]]; then
    if ! wget https://github.com/git/git/archive/refs/tags/v${ver}.tar.gz -O /home/lixq/src/git-${ver}.tar.gz; then
        rm -f /home/lixq/src/git-${ver}.tar.gz*
        echo "Need /home/lixq/src/git-${ver}.tar.gz (https://github.com/git/git/archive/refs/tags/v${ver}.tar.gz)"
        exit 1
    fi
fi

cd /home/lixq/src || exit 1
rm -rf git-${ver} /home/lixq/toolchains/git-${ver}
tar -xvf git-${ver}.tar.gz
cd /home/lixq/src/git-${ver} || exit 1
make CC=/home/lixq/toolchains/gcc/bin/gcc \
     CXX=/home/lixq/toolchains/gcc/bin/g++ \
     CPP=/home/lixq/toolchains/gcc/bin/cpp \
     LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64 \
     LD_LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64 \
     LD_RUN_PATH=/home/lixq/toolchains/gcc/lib64 \
     prefix=/home/lixq/toolchains/git-${ver} || exit 1
make CC=/home/lixq/toolchains/gcc/bin/gcc \
     CXX=/home/lixq/toolchains/gcc/bin/g++ \
     CPP=/home/lixq/toolchains/gcc/bin/cpp \
     LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64 \
     LD_LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64 \
     LD_RUN_PATH=/home/lixq/toolchains/gcc/lib64 \
     prefix=/home/lixq/toolchains/git-${ver} install || exit 1
if [[ -d /home/lixq/toolchains/git-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm git
    ln -s git-${ver} git
fi
