#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=4.4.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="$DESTDIR/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LD_RUN_PATH="$DESTDIR/usr/lib64"

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

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
./autogen.sh || exit 1
./configure "--prefix=$DESTDIR/usr" || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1
