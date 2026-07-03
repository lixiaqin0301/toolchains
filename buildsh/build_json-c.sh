#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=0.19-20260627
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH="/home/lixq/toolchains/cmake/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

cd /home/lixq/src
rm -rf "json-c-$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/json-c-$name-$ver"
mkdir json-c-build
cd "/home/lixq/src/json-c-$name-$ver/json-c-build"
#cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_INSTALL_PREFIX="$DESTDIR/usr" -DCMAKE_INSTALL_LIBDIR=lib ..
cmake -DDISABLE_WERROR=ON -DCMAKE_INSTALL_PREFIX="$DESTDIR/usr" ..
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
