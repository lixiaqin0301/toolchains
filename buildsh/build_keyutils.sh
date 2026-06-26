#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=1.6.3
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
make -s "-j$(nproc)"
make -s "-j$(nproc)" install DESTDIR="$DESTDIR" PREFIX=/usr

cd "$DESTDIR"/lib64
rm libkeyutils.so
ln -s libkeyutils.so.1 libkeyutils.so

for d in lib lib64; do
    mkdir -p "$DESTDIR"/usr/$d
    cd "$DESTDIR"/usr/$d
    ln -s ../../lib64/libkeyutils.so.1.* libkeyutils.so.1
    ln -s libkeyutils.so.1 libkeyutils.so
done
