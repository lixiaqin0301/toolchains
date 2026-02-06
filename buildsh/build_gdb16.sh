#!/bin/bash

name=gdb
ver=16.3
DESTDIR=$1
srcpath=/home/lixq/src/${name}-${ver}.tar.gz
core_analyzer=2.24.0

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1
[[ -f /home/lixq/src/core_analyzer-${core_analyzer}.tar.gz ]] || exit 1

export PATH="$DESTDIR/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig:$DESTDIR/usr/share/pkgconfig"
export CPPFLAGS="-isystem $DESTDIR/usr/include"
export LDFLAGS="-L$DESTDIR/usr/lib -L$DESTDIR/usr/lib64 -Wl,-rpath-link,$DESTDIR/usr/lib:$DESTDIR/usr/lib64 -Wl,-rpath,$DESTDIR/usr/lib:$DESTDIR/usr/lib64"

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
[[ -d $DESTDIR/usr/share ]] || mkdir -p "$DESTDIR/usr/share"
cp -r /home/lixq/toolchains/gcc/usr/share/gcc-* "$DESTDIR/usr/share"
for f in /home/lixq/toolchains/gcc/usr/lib64/libstdc++.so.*-gdb.py; do
    sed "s;/home/lixq/toolchains/gcc;$DESTDIR;" /home/lixq/toolchains/gcc/usr/lib64/libstdc++.so.6.0.34-gdb.py > "$DESTDIR/usr/lib64/$(basename "$f")"
done

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
rm -rf core_analyzer-${core_analyzer}
tar -xf core_analyzer-${core_analyzer}.tar.gz || exit 1
cp -rLvp core_analyzer-${core_analyzer}/gdbplus/gdb-${ver}/gdb "$name-$ver" || exit 1
mkdir "$name-$ver/build"
cd "$name-$ver/build" || exit 1
rm -rf "$DESTDIR/usr/bin/python"
ln -s "$DESTDIR/usr/bin/python3" "$DESTDIR/usr/bin/python"
../configure "--prefix=$DESTDIR/usr" --with-python --with-separate-debug-dir=/usr/lib/debug || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1
rm -rf "$DESTDIR/usr/bin/python"
