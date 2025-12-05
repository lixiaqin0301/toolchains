#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=21.1.7
DESTDIR=$1
srcpath=/home/lixq/src/$name-project-$ver.src.tar.xz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/cmake/usr/bin:/home/lixq/toolchains/gcc/usr/bin:$DESTDIR/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig"
export CFLAGS="-isystem $DESTDIR/usr/include"
export CXXFLAGS="-isystem $DESTDIR/usr/include"
export CPPFLAGS="-isystem $DESTDIR/usr/include"
export LDFLAGS="-L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -L$DESTDIR/lib -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib -static-libgcc -static-libstdc++ -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

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

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src/
cd /home/lixq/src/ || exit 1
rm -rf "$name-project-$ver.src"
tar -xf "$srcpath" || exit 1
mkdir "$name-project-$ver.src/build" || exit 1
cd "$name-project-$ver.src/build" || exit 1
cmake "-DCMAKE_INCLUDE_PATH=$DESTDIR/usr/include" "-DCMAKE_LIBRARY_PATH=$DESTDIR/usr/lib" \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
    -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lldb" \
    -DLLDB_ENABLE_LIBEDIT=1 \
    -DLLDB_ENABLE_CURSES=1 \
    -DLLDB_ENABLE_LZMA=1 \
    -DLLDB_ENABLE_LIBXML2=1 \
    -DLLDB_ENABLE_PYTHON=1 \
    -DLLDB_ENABLE_LUA=1 \
    "-DLUA_INCLUDE_DIR=$DESTDIR/usr/include" \
    "-DLUA_LIBRARIES=$DESTDIR/usr/lib/liblua.a" \
    -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind" \
    "-DCMAKE_INSTALL_PREFIX=$DESTDIR/usr" -G "Unix Makefiles" ../llvm
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1