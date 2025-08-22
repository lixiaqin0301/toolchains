#!/bin/bash

name=brotli
ver=1.1.0
srcpath=/home/lixq/src/${name}-${ver}.tar.gz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ "$DESTDIR" == */${name} ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" ${name}
    export PATH="/home/lixq/toolchains/cmake/bin:$PATH"
    export CC="gcc"
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf $srcpath || exit 1
mkdir ${name}-${ver}/out
cd /home/lixq/src/${name}-${ver}/out || exit 1
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$DESTDIR/usr" \
    -DCMAKE_C_COMPILER="$CC" \
    -DCMAKE_C_FLAGS="$CFLAGS $LDFLAGS" \
    -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
    .. || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
cmake --build . --config Release --target install || exit 1
