#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=6.3
DESTDIR=$1
srcpath=/home/lixq/src/$name.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
./configure "--prefix=$DESTDIR/usr" --with-shared --enable-widec --without-ada || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1
cd "$DESTDIR/usr/include/" || exit 1
for f in ncursesw/*.h; do
    ln -s "$f" .
done
