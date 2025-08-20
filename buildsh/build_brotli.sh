#!/bin/bash

ver=1.1.0
DESTDIR=/home/lixq/toolchains/brotli-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/brotli-${ver}.tar.gz ]]; then
    echo "wget https://github.com/google/brotli/archive/refs/tags/v${ver}.tar.gz -O brotli-${ver}.tar.gz"
    exit 1
fi

if [[ "$DESTDIR" == */brotli-* ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" brotli
    export PATH="/home/lixq/toolchains/cmake/bin:$PATH"
    export CC="gcc"
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf brotli-${ver}
tar -xf /home/lixq/35share-rd/src/brotli-${ver}.tar.gz
mkdir brotli-${ver}/out
cd /home/lixq/src/brotli-${ver}/out || exit 1
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$DESTDIR/usr" \
    -DCMAKE_C_COMPILER="$CC" \
    -DCMAKE_C_FLAGS="$CFLAGS $LDFLAGS" \
    -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
    .. || exit 1
[[ "$DESTDIR" == */brotli-* ]] && rm -rf "$DESTDIR"
cmake --build . --config Release --target install || exit 1

if [[ "$DESTDIR" == */brotli-* ]]; then
    cd "$DESTDIR" || exit 1
    cd .. || exit 1
    rm -f brotli
    ln -s brotli-${ver} brotli
fi
