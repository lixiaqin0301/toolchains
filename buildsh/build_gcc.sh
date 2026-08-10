#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=16.2.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
gmp='gmp-6.3.0.tar.bz2'
mpfr='mpfr-4.2.2.tar.bz2'
mpc='mpc-1.3.1.tar.gz'
isl='isl-0.24.tar.bz2'
gettext='gettext-0.22.tar.gz'
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]
[[ -f /home/lixq/src/$gmp ]]
[[ -f /home/lixq/src/$mpfr ]]
[[ -f /home/lixq/src/$mpc ]]
[[ -f /home/lixq/src/$isl ]]
[[ -f /home/lixq/src/$gettext ]]

if [[ $DESTDIR == /opt/gcc ]]; then
    export PATH="/home/lixq/toolchains/gcc/usr/bin:/opt/rh/devtoolset-11/root/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
    export LDFLAGS="-L/home/lixq/toolchains/gcc/usr/lib64 -Wl,-rpath-link,/home/lixq/toolchains/gcc/usr/lib64 -Wl,-rpath,/opt/gcc/usr/lib64"
else
    export PATH="/opt/gcc/usr/bin:/opt/rh/devtoolset-11/root/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
    export LDFLAGS="-L/opt/gcc/usr/lib64 -Wl,-rpath-link,/opt/gcc/usr/lib64 -Wl,-rpath,/home/lixq/toolchains/gcc/usr/lib64"
fi

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
cp /home/lixq/src/$gmp .
cp /home/lixq/src/$mpfr .
cp /home/lixq/src/$mpc .
cp /home/lixq/src/$isl .
cp /home/lixq/src/$gettext .
./contrib/download_prerequisites
mkdir -p "/home/lixq/src/$name-$ver/build"
cd "/home/lixq/src/$name-$ver/build"
../configure --prefix="$DESTDIR/usr" --disable-multilib --enable-ld
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
cd "$DESTDIR/usr/bin"
ln -s gcc cc
