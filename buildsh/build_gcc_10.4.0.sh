#!/bin/bash

name=gcc
ver=10.4.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
gmp='gmp-6.1.0.tar.bz2'
mpfr='mpfr-3.1.6.tar.bz2'
mpc='mpc-1.0.3.tar.gz'
isl='isl-0.18.tar.bz2'

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1
[[ -f /home/lixq/src/$gmp  ]] || exit 1
[[ -f /home/lixq/src/$mpfr ]] || exit 1
[[ -f /home/lixq/src/$mpc  ]] || exit 1
[[ -f /home/lixq/src/$isl  ]] || exit 1

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
cp /home/lixq/src/$gmp . || exit 1
cp /home/lixq/src/$mpfr . || exit 1
cp /home/lixq/src/$mpc . || exit 1
cp /home/lixq/src/$isl . || exit 1
./contrib/download_prerequisites
mkdir build
cd build || exit 1
../configure --prefix="$DESTDIR/usr" --enable-languages=c,c++ --disable-multilib || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1
