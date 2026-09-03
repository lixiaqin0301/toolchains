#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=2.7.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tgz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export MANPATH=
export PCP_DIR=
export LD_LIBRARY_PATH=
export PKG_CONFIG_PATH=
export INFOPATH=
export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig"
#export CPATH="$DESTDIR/usr/include"
#export LIBRARY_PATH="$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"
export CPPFLAGS="-isystem $DESTDIR/usr/include"
export LDFLAGS="-L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -L$DESTDIR/lib -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
./configure "--prefix=$DESTDIR/usr" --with-tls=openssl --disable-slapd
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
