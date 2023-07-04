#!/bin/bash

ver=13.1.0

gmp='gmp-6.2.1.tar.bz2'
mpfr='mpfr-4.1.0.tar.bz2'
mpc='mpc-1.2.1.tar.gz'
isl='isl-0.24.tar.bz2'

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src

if [[ ! -f /home/lixq/src/gcc-${ver}.tar.gz ]]; then
    echo "wget http://mirrors.ustc.edu.cn/gnu/gcc/gcc-${ver}/gcc-${ver}.tar.gz -O /home/lixq/src/gcc-${ver}.tar.gz"
    exit 1
fi
if [[ ! -f /home/lixq/src/${gmp} ]]; then
    echo "wget http://mirrors.ustc.edu.cn/gnu/gmp/${gmp} -O /home/lixq/src/${gmp}"
    exit 1
fi
if [[ ! -f /home/lixq/src/${mpfr} ]]; then
    echo "wget http://mirrors.ustc.edu.cn/gnu/mpfr/${mpfr} -O /home/lixq/src/${mpfr}"
    exit 1
fi
if [[ ! -f /home/lixq/src/${mpc} ]]; then
    echo "wget http://mirrors.ustc.edu.cn/gnu/mpc/${mpc} -O /home/lixq/src/${mpc}"
    exit 1
fi
if [[ ! -f /home/lixq/src/${isl} ]]; then
    echo "wget https://gcc.gnu.org/pub/gcc/infrastructure/${isl} -O /home/lixq/src/${isl}"
    exit 1
fi

cd /home/lixq/src || exit 1
rm -rf gcc-${ver}
tar -xvf gcc-${ver}.tar.gz
cd /home/lixq/src/gcc-${ver} || exit 1
cp /home/lixq/src/${gmp} .
cp /home/lixq/src/${mpfr} .
cp /home/lixq/src/${mpc} .
cp /home/lixq/src/${isl} .
./contrib/download_prerequisites
mkdir -p /home/lixq/src/gcc-${ver}/build
cd /home/lixq/src/gcc-${ver}/build || exit 1
../configure --prefix=/home/lixq/toolchains/gcc-${ver} --disable-multilib || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/gcc-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/gcc-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f gcc
    ln -s gcc-${ver} gcc
fi
