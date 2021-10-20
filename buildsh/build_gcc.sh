#!/bin/bash

gmp='gmp-6.1.0.tar.bz2'
mpfr='mpfr-3.1.6.tar.bz2'
mpc='mpc-1.0.3.tar.gz'
isl='isl-0.18.tar.bz2'

[[ -d /home/lixq/toolchains/src ]] || mkdir -p /home/lixq/toolchains/src

if [[ ! -f /home/lixq/toolchains/src/gcc-11.2.0.tar.gz ]]; then
    if ! wget http://mirrors.ustc.edu.cn/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.gz -O /home/lixq/toolchains/src/gcc-11.2.0.tar.gz; then
        rm -f /home/lixq/toolchains/src/gcc-11.2.0.tar.gz*
        echo "Need /home/lixq/toolchains/src/gcc-11.2.0.tar.gz (http://mirrors.ustc.edu.cn/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.gz)"
        exit 1
    fi
fi
if [[ ! -f /home/lixq/toolchains/src/$gmp ]]; then
    if ! wget http://mirrors.ustc.edu.cn/gnu/gmp/$gmp -O /home/lixq/toolchains/src/$gmp; then
        rm -f /home/lixq/toolchains/src/${gmp}*
        echo "Need /home/lixq/toolchains/src/$gmp (http://mirrors.ustc.edu.cn/gnu/gmp/$gmp)"
        exit 1
    fi
fi
if [[ ! -f /home/lixq/toolchains/src/$mpfr ]]; then
    if ! wget http://mirrors.ustc.edu.cn/gnu/mpfr/$mpfr -O /home/lixq/toolchains/src/$mpfr; then
        echo "Need /home/lixq/toolchains/src/$mpfr (http://mirrors.ustc.edu.cn/gnu/mpfr/$mpfr)"
        exit 1
    fi
fi
if [[ ! -f /home/lixq/toolchains/src/$mpc ]]; then
    if ! wget http://mirrors.ustc.edu.cn/gnu/mpc/$mpc -O /home/lixq/toolchains/src/$mpc; then
        echo "Need /home/lixq/toolchains/src/$mpc (http://mirrors.ustc.edu.cn/gnu/mpc/$mpc)"
        exit 1
    fi
fi
if [[ ! -f /home/lixq/toolchains/src/$isl ]]; then
    if ! wget https://gcc.gnu.org/pub/gcc/infrastructure/$isl -O /home/lixq/toolchains/src/$isl; then
        echo "Need /home/lixq/toolchains/src/$isl (https://gcc.gnu.org/pub/gcc/infrastructure/$isl)"
        exit 1
    fi
fi

cd /home/lixq/toolchains/src || exit 1
rm -rf gcc-11.2.0
tar -xvf gcc-11.2.0.tar.gz
cd /home/lixq/toolchains/src/gcc-11.2.0 || exit 1
cp /home/lixq/toolchains/src/$gmp .
cp /home/lixq/toolchains/src/$mpfr .
cp /home/lixq/toolchains/src/$mpc .
cp /home/lixq/toolchains/src/$isl .
./contrib/download_prerequisites
mkdir -p /home/lixq/toolchains/src/gcc-11.2.0/build
cd /home/lixq/toolchains/src/gcc-11.2.0/build || exit 1
rm -rf /home/lixq/toolchains/gcc-11.2.0
../configure --prefix=/home/lixq/toolchains/gcc-11.2.0 --disable-multilib
make
make install
if [[ -d /home/lixq/toolchains/gcc-11.2.0 ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f gcc
    ln -s gcc-11.2.0 gcc
fi
