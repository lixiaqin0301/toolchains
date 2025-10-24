#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=v2.15.1
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
sed -i 's;1.16.3;1.13.4;' configure.ac
./autogen.sh || exit 1
./configure "--prefix=$DESTDIR/usr" --enable-static || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1
