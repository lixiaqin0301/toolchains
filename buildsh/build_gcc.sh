#!/bin/bash

ver=14.1.0

gmp='gmp-6.2.1.tar.bz2'
mpfr='mpfr-4.1.0.tar.bz2'
mpc='mpc-1.2.1.tar.gz'
isl='isl-0.24.tar.bz2'
gettext='gettext-0.22.tar.gz'

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src

cd /home/lixq/35share-rd/src || exit 1
need_exit=no
if [[ ! -f gcc-${ver}.tar.gz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/gcc-${ver}/gcc-${ver}.tar.gz -O gcc-${ver}.tar.gz"
    need_exit=yes
fi
if [[ ! -f ${gmp} ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/gmp/${gmp} -O ${gmp}"
    need_exit=yes
fi
if [[ ! -f ${mpfr} ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/mpfr/${mpfr} -O ${mpfr}"
    need_exit=yes
fi
if [[ ! -f ${mpc} ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/mpc/${mpc} -O ${mpc}"
    need_exit=yes
fi
if [[ ! -f ${isl} ]]; then
    echo "wget https://gcc.gnu.org/pub/gcc/infrastructure/${isl} -O ${isl}"
    need_exit=yes
fi
if [[ ! -f ${gettext} ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/gnu/gettext/${gettext} -O ${gettext}"
    need_exit=yes
fi
if [[ "$need_exit" == "yes" ]]; then
    exit 1
fi

cd /home/lixq/src || exit 1
rm -rf gcc-${ver}
tar -xvf /home/lixq/35share-rd/src/gcc-${ver}.tar.gz
cd /home/lixq/src/gcc-${ver} || exit 1
cp /home/lixq/35share-rd/src/${gmp} .
cp /home/lixq/35share-rd/src/${mpfr} .
cp /home/lixq/35share-rd/src/${mpc} .
cp /home/lixq/35share-rd/src/${isl} .
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
