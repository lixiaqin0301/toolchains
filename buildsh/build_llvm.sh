#!/bin/bash

name=llvm-project
ver=20.1.8
srcpath=/home/lixq/src/${name}-${ver}.tar.xz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ "$DESTDIR" == */${name} ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" gcc Python lua
    export PATH=/home/lixq/toolchains/cmake/usr/bin:/home/lixq/toolchains/swig/usr/bin:$PATH
    lua_include_dir="$(dirname "$DESTDIR")/lua/usr/include"
    lua_libraries="$(dirname "$DESTDIR")/lua/usr/lib/liblua.a"
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
    lua_include_dir="$DESTDIR/usr/include"
    lua_libraries="$DESTDIR/usr/lib/liblua.a"
fi

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src/
cd /home/lixq/src/ || exit 1
rm -rf ${name}-${ver}.arc
tar -xf $srcpath || exit 1
mkdir /home/lixq/src/${name}-${ver}.src/build || exit 1
cd /home/lixq/src/${name}-${ver}.src/build || exit 1
cmake -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
    -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lldb" \
    -DLLDB_ENABLE_LIBEDIT=1 \
    -DLLDB_ENABLE_CURSES=1 \
    -DLLDB_ENABLE_LZMA=1 \
    -DLLDB_ENABLE_LIBXML2=1 \
    -DLLDB_ENABLE_PYTHON=1 \
    -DLLDB_ENABLE_LUA=1 \
    -DLUA_INCLUDE_DIR="$lua_include_dir" \
    -DLUA_LIBRARIES="$lua_libraries" \
    -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind" \
    -DCMAKE_INSTALL_PREFIX="$DESTDIR/usr" -G "Unix Makefiles" ../llvm
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install || exit 1