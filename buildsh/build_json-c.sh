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
export PATH="/home/lixq/toolchains/cmake/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

cd /home/lixq/src
rm -rf "json-c-$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/json-c-$name-$ver"
mkdir json-c-build
cd "/home/lixq/src/json-c-$name-$ver/json-c-build"
cmake -DDISABLE_WERROR=ON -DCMAKE_INSTALL_PREFIX="$DESTDIR/usr" ..
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
