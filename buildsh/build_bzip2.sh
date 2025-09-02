#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=1.0.8
DESTDIR=$1
srcpath=/home/lixq/src/${name}-${ver}.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
#sed -i -e "s;CFLAGS=;CFLAGS=$CFLAGS ;" -e "s;LDFLAGS=;LDFLAGS=$LDFLAGS;" Makefile
#sed -i -e "/CC=/a LDFLAGS=$LDFLAGS" -e "s;LDFLAGS=;LDFLAGS=$LDFLAGS;" -e "s;\$(CC) \$(CFLAGS) -o;\$(CC) \$(CFLAGS) \$(LDFLAGS) -o;" -e "s;\$(CC) -shared;\$(CC) \$(LDFLAGS) -shared;" Makefile-libbz2_so
make -s "-j$(nproc)" -f Makefile-libbz2_so || exit 1
make -s "-j$(nproc)" install "PREFIX=$DESTDIR/usr" || exit 1
cp libbz2.so.$ver "$DESTDIR/usr/lib/libbz2.so.$ver"
cd "$DESTDIR/usr/lib/" || exit 1
ln -sf libbz2.so.$ver libbz2.so
ln -sf libbz2.so.$ver libbz2.so.${ver%.*.*}
ln -sf libbz2.so.$ver libbz2.so.${ver%.*}
