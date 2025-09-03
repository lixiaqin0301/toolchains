#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=5.3
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export CPATH="/home/lixq/toolchains/boost_1_88_0/usr/include"
export LIBRARY_PATH="/home/lixq/toolchains/boost_1_88_0/usr/lib"
export LDFLAGS="-L$LIBRARY_PATH -Wl,-rpath-link,$LIBRARY_PATH"
export LD_RUN_PATH="$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
./configure "--prefix=$DESTDIR/usr" || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1

[[ -d $DESTDIR/usr/lib ]] || mkdir -p "$DESTDIR/usr/lib"
[[ -f $DESTDIR/usr/lib/libboost_system.so.1.88.0 ]] || cp /home/lixq/toolchains/boost_1_88_0/usr/lib/libboost_system.so.1.88.0 "$DESTDIR/usr/lib/libboost_system.so.1.88.0"
[[ -d $DESTDIR/lib64 ]] || mkdir -p "$DESTDIR/lib64"
for f in "$DESTDIR/usr/bin/"* "$DESTDIR/usr/libexec/systemtap/stap"*; do
    ldd "$f" | grep ' => /[^h]' | awk '{print $3}' | while read -r lib; do
        if [[ ! -f $DESTDIR$lib ]]; then
            [[ -d $(dirname "$DESTDIR$lib") ]] || mkdir -p "$(dirname "$DESTDIR$lib")"
            if [[ -f /home/lixq/toolchains/glibc$lib ]]; then
                cp "/home/lixq/toolchains/glibc$lib" "$DESTDIR$lib"
            else
                cp "$lib" "$DESTDIR$lib"
            fi
        fi
        patchelf --set-rpath "$LD_RUN_PATH" "$DESTDIR$lib"
    done
    patchelf --set-interpreter "$DESTDIR/lib64/ld-linux-x86-64.so.2" "$f"
done
cp /home/lixq/toolchains/glibc/lib64/ld-linux-x86-64.so.2 "$DESTDIR/lib64"