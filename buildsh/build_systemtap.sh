#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=$1
DESTDIR=$2
srcpath=/share-rd/cdn_prd_cache/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export MANPATH=
export PCP_DIR=
export LD_LIBRARY_PATH=
export PKG_CONFIG_PATH=
export INFOPATH=
export PATH="$DESTDIR/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export CPPFLAGS="--sysroot=$DESTDIR"
export CPATH="/home/lixq/toolchains/boost/usr/include:$DESTDIR/usr/include"
export LIBRARY_PATH="/home/lixq/toolchains/boost/usr/lib:$DESTDIR/usr/lib"
export LDFLAGS="-L/home/lixq/toolchains/boost/usr/lib -L$DESTDIR/lib64 -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/lib64:$LIBRARY_PATH --sysroot=$DESTDIR -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"
export LD_RUN_PATH="$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"
export GCONV_PATH="$DESTDIR/usr/lib64/gconv"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
./configure "--prefix=$DESTDIR/usr"
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
