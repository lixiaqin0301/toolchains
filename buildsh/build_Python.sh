#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=3.14.1
DESTDIR=$1
srcpath=/home/lixq/src/${name}-${ver}.tar.xz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig"
if [[ -f $DESTDIR/lib64/ld-linux-x86-64.so.2 ]]; then
    export CPPFLAGS="--sysroot=$DESTDIR"
    export LDFLAGS="-L$DESTDIR/lib64 -Wl,-rpath-link,$DESTDIR/lib64 --sysroot=$DESTDIR -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"
else
    export LDFLAGS="-Wl,-rpath,$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"
fi

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

function recover() {
    [[ -f /home/lixq/toolchains/gcc/usr/lib/gcc/x86_64-pc-linux-gnu/15.2.0/include-fixed/openssl/bn.h.bak ]] && mv /home/lixq/toolchains/gcc/usr/lib/gcc/x86_64-pc-linux-gnu/15.2.0/include-fixed/openssl/bn.h.bak /home/lixq/toolchains/gcc/usr/lib/gcc/x86_64-pc-linux-gnu/15.2.0/include-fixed/openssl/bn.h
}
trap recover EXIT
mv /home/lixq/toolchains/gcc/usr/lib/gcc/x86_64-pc-linux-gnu/15.2.0/include-fixed/openssl/bn.h /home/lixq/toolchains/gcc/usr/lib/gcc/x86_64-pc-linux-gnu/15.2.0/include-fixed/openssl/bn.h.bak

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
./configure "--prefix=$DESTDIR/usr" --enable-shared || exit 1
make -s "-j$(nproc)" || exit 1
make -s -j"$(nproc)" install || exit 1
