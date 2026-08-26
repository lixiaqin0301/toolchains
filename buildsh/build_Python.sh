#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=3.14.7
DESTDIR=$1
srcpath=/home/lixq/src/${name}-${ver}.tar.xz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export MANPATH=
export PCP_DIR=
export LD_LIBRARY_PATH=
export PKG_CONFIG_PATH=
export INFOPATH=
export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export PKG_CONFIG_PATH="$DESTDIR/lib64/pkgconfig:$DESTDIR/usr/lib64/pkgconfig:$DESTDIR/lib/pkgconfig:$DESTDIR/usr/lib/pkgconfig"
if [[ -f $DESTDIR/lib64/ld-linux-x86-64.so.2 ]]; then
    export CPPFLAGS="--sysroot=$DESTDIR"
    export LDFLAGS="-L$DESTDIR/lib64 -Wl,-rpath-link,$DESTDIR/lib64 --sysroot=$DESTDIR -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"
else
    export LDFLAGS="-Wl,-rpath,$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"
fi

GCC_INCLUDE_FIXED=""
for d in /home/lixq/toolchains/gcc/usr/lib/gcc/x86_64-pc-linux-gnu/*/include-fixed/; do
    [[ -d "$d" ]] || continue
    GCC_INCLUDE_FIXED=$(realpath "$d")
    break
done
function recover() {
    [[ -d "$GCC_INCLUDE_FIXED.bak" ]] && mv "$GCC_INCLUDE_FIXED.bak" "$GCC_INCLUDE_FIXED"
    "$DESTDIR/usr/bin/python3" -c 'import ssl'
}
trap recover EXIT

mkdir -p "$DESTDIR/usr/lib64"
cd "$DESTDIR/usr/lib64" || exit 1
for p in /home/lixq/toolchains/gcc/usr/lib64/libgcc* /home/lixq/toolchains/gcc/usr/lib64/libstdc++.s*[0-9o]; do
    [[ -f $(basename "$p") ]] && continue
    if [[ -L $p ]]; then
        ln -sf "$(readlink "$p")" "$(basename "$p")"
    else
        cp "$p" .
    fi
done

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
[[ -f $DESTDIR/lib64/ld-linux-x86-64.so.2 ]] && mv "$GCC_INCLUDE_FIXED" "$GCC_INCLUDE_FIXED.bak"
./configure "--prefix=$DESTDIR/usr" --enable-shared
make -s -j"$(nproc)"
make -s -j"$(nproc)" install
