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
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig:$DESTDIR/usr/lib64/pkgconfig"
export CPPFLAGS="-I$DESTDIR/usr/include"
export LDFLAGS="-L$DESTDIR/usr/lib64 -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/usr/lib64:$DESTDIR/usr/lib -Wl,-rpath,$DESTDIR/usr/lib64:$DESTDIR/usr/lib"

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
make -s "-j$(nproc)"
make -s "-j$(nproc)" install PREFIX="$DESTDIR"/usr
