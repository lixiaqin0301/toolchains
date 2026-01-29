#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=3.6.1
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LIBRARY_PATH="$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"
export LD_RUN_PATH="$LIBRARY_PATH"

[[ -d $DESTDIR/usr/lib64 ]] || mkdir -p "$DESTDIR/usr/lib64"
cd "$DESTDIR/usr/lib64" || exit 1
for p in /home/lixq/toolchains/gcc/usr/lib64/libgcc* /home/lixq/toolchains/gcc/usr/lib64/libstdc++.s*[0-9o]; do
    [[ -f $(basename "$p") ]] && continue
    if [[ -L $p ]]; then
        ln -sf "$(readlink "$p")" "$(basename "$p")"
    else
        cp "$p" .
    fi
done

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
./config "--prefix=$DESTDIR/usr" --libdir=lib || exit 1
make -s "-j$(nproc)" || exit 1
[[ $DESTDIR == */${name} ]] && rm -rf "$DESTDIR"
make -s "-j$(nproc)" install || exit 1
