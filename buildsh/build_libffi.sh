#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=3.6.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
[[ -n "$DESTDIR" ]]
[[ -f "$srcpath" ]]

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
./autogen.sh
./configure "--prefix=$DESTDIR/usr"
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
