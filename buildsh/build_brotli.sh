#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=1.1.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/cmake/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig"
export CFLAGS="-isystem $DESTDIR/usr/include"
export CXXFLAGS="-isystem $DESTDIR/usr/include"
export CPPFLAGS="-isystem $DESTDIR/usr/include"
export LDFLAGS="-L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -L$DESTDIR/lib -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib -static-libgcc -static-libstdc++ -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
mkdir "$name-$ver/out"
cd "$name-$ver/out" || exit 1
cmake -DCMAKE_BUILD_TYPE=Release "-DCMAKE_INSTALL_PREFIX=$DESTDIR/usr" \
    "-DCMAKE_C_FLAGS=$CFLAGS $LDFLAGS" \
    "-DCMAKE_EXE_LINKER_FLAGS=$LDFLAGS" \
    .. || exit 1
cmake --build . --config Release --target install || exit 1
