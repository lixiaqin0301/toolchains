#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=17.1
DESTDIR=$1
srcpath=/home/lixq/src/${name}-${ver}.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/gcc/usr/bin:$DESTDIR/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig"
export CPPFLAGS="-isystem $DESTDIR/usr/include"
export LDFLAGS="-static-libgcc -static-libstdc++ -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/usr/lib -Wl,-rpath,$DESTDIR/usr/lib"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
mkdir "$name-$ver/build"
cd "$name-$ver/build" || exit 1
rm -rf "$DESTDIR/usr/bin/python"
ln -s "$DESTDIR/usr/bin/python3" "$DESTDIR/usr/bin/python"
../configure "--prefix=$DESTDIR/usr" --with-python || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1
rm -rf "$DESTDIR/usr/bin/python"
