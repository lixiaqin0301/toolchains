#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=16.1.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
gmp='gmp-6.3.0.tar.bz2'
mpfr='mpfr-4.2.2.tar.bz2'
mpc='mpc-1.3.1.tar.gz'
isl='isl-0.24.tar.bz2'
gettext='gettext-0.22.tar.gz'

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1
[[ -f /home/lixq/src/$gmp     ]] || exit 1
[[ -f /home/lixq/src/$mpfr    ]] || exit 1
[[ -f /home/lixq/src/$mpc     ]] || exit 1
[[ -f /home/lixq/src/$isl     ]] || exit 1
[[ -f /home/lixq/src/$gettext ]] || exit 1

if [[ $DESTDIR == /opt/gcc ]]; then
    export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    export LDFLAGS="-L/home/lixq/toolchains/gcc/usr/lib64 -Wl,-rpath-link,/home/lixq/toolchains/gcc/usr/lib64 -Wl,-rpath,/opt/gcc/usr/lib64"
else
    export PATH="/opt/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    export LDFLAGS="-L/opt/gcc/usr/lib64 -Wl,-rpath-link,/opt/gcc/usr/lib64 -Wl,-rpath,/home/lixq/toolchains/gcc/usr/lib64"
fi

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "/home/lixq/src/$name-$ver" || exit 1
cp /home/lixq/src/$gmp . || exit 1
cp /home/lixq/src/$mpfr . || exit 1
cp /home/lixq/src/$mpc . || exit 1
cp /home/lixq/src/$isl . || exit 1
cp /home/lixq/src/$gettext . || exit 1
./contrib/download_prerequisites
mkdir -p "/home/lixq/src/$name-$ver/build"
cd "/home/lixq/src/$name-$ver/build" || exit 1
../configure --prefix="$DESTDIR/usr" --disable-multilib --enable-ld || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1
cd "$DESTDIR/usr/bin" || exit 1
ln -s gcc cc
