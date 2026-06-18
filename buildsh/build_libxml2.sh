#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=2.15.3
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "/home/lixq/src/$name-$ver"
sed -i 's;1.16.3;1.13.4;' configure.ac
./autogen.sh
./configure "--prefix=$DESTDIR/usr" --enable-static
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
