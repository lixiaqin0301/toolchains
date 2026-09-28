#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=$1
DESTDIR=$2
srcpath=/share-rd/cdn_prd_cache/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export MANPATH=
export PCP_DIR=
export LD_LIBRARY_PATH=
export PKG_CONFIG_PATH=
export INFOPATH=
export PATH="$DESTDIR/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export CPATH="/home/lixq/toolchains/boost/usr/include"
export LIBRARY_PATH="$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/usr/lib:/home/lixq/toolchains/boost/usr/lib"
export LD_RUN_PATH="$LIBRARY_PATH"
export LDFLAGS="-L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -L$DESTDIR/usr/lib -L/home/lixq/toolchains/boost/usr/lib -Wl,-rpath-link,$LIBRARY_PATH --sysroot=$DESTDIR -Wl,-rpath,$LD_RUN_PATH -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"

mkdir -p "$DESTDIR/usr/lib64"
cd "$DESTDIR/usr/lib64"
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

# source highlight 3.1.9 不支持 c++ 17 以上的版本
sed -i 's/ throw *(IOException)//' lib/srchilite/fileutil.h lib/srchilite/fileutil.cc
sed -i -E 's/throw *\( *\)/noexcept/g' lib/srchilite/*exception.h lib/srchilite/*exception.cpp

./configure "--prefix=$DESTDIR/usr" --with-boost=/home/lixq/toolchains/boost/usr
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
