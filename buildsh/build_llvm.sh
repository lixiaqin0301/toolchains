#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=22.1.8
DESTDIR=$1
srcpath=/home/lixq/src/$name-project-$ver.src.tar.xz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH="/home/lixq/toolchains/cmake/usr/bin:/home/lixq/toolchains/gcc/usr/bin:$DESTDIR/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig:$DESTDIR/usr/lib64/pkgconfig:$DESTDIR/usr/share/pkgconfig"
export LDFLAGS="-L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -L$DESTDIR/lib -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

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

cd /home/lixq/src
rm -rf "$name-project-$ver.src"
tar -xf "$srcpath"
mkdir "$name-project-$ver.src/build"
cd "/home/lixq/src/$name-project-$ver.src/build"
if [[ $DESTDIR == */lldb ]]; then
    cmake -G "Unix Makefiles" \
        -DCMAKE_INCLUDE_PATH="$DESTDIR/usr/include" \
        -DCMAKE_LIBRARY_PATH="$DESTDIR/lib64;$DESTDIR/usr/lib64;$DESTDIR/lib;$DESTDIR/usr/lib" \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_DIR=/home/lixq/toolchains/llvm/usr/lib/cmake/llvm \
        -DClang_DIR=/home/lixq/toolchains/llvm/usr/lib/cmake/clang \
        -DCMAKE_C_FLAGS="-isystem $DESTDIR/usr/include" \
        -DCMAKE_CXX_FLAGS="-isystem $DESTDIR/usr/include" \
        -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
        -DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS" \
        -DCMAKE_MODULE_LINKER_FLAGS="$LDFLAGS" \
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
        -DLLDB_ENABLE_LIBEDIT=1 \
        -DLibEdit_INCLUDE_DIRS="$DESTDIR/usr/include" \
        -DLibEdit_LIBRARIES="$DESTDIR/usr/lib/libedit.so" \
        -DLLDB_ENABLE_CURSES=1 \
        -DCURSES_NEED_NCURSES=TRUE \
        -DCURSES_LIBRARY="$DESTDIR/usr/lib/libncurses.so" \
        -DCURSES_INCLUDE_PATH="$DESTDIR/usr/include" \
        -DLLDB_ENABLE_LZMA=1 \
        -DLIBLZMA_INCLUDE_DIR="$DESTDIR/usr/include" \
        -DLIBLZMA_LIBRARY="$DESTDIR/usr/lib/liblzma.so" \
        -DLLDB_ENABLE_LIBXML2=1 \
        -DLIBXML2_INCLUDE_DIR="$DESTDIR/usr/include/libxml2" \
        -DLIBXML2_LIBRARIES="$DESTDIR/usr/lib/libxml2.so" \
        -DLLDB_ENABLE_PYTHON=1 \
        -DPython3_ROOT_DIR="$DESTDIR/usr" \
        -DPython3_EXECUTABLE="$DESTDIR/usr/bin/python3" \
        -DLLDB_ENABLE_LUA=1 \
        -DLUA_INCLUDE_DIR="$DESTDIR/usr/include" \
        -DLUA_LIBRARIES="$DESTDIR/usr/lib/liblua.a" \
        -DCMAKE_INSTALL_PREFIX="$DESTDIR/usr" \
        ../lldb
else
    cmake -G "Unix Makefiles" \
        -DCMAKE_INCLUDE_PATH="$DESTDIR/usr/include" \
        -DCMAKE_LIBRARY_PATH="$DESTDIR/lib64;$DESTDIR/usr/lib64;$DESTDIR/lib;$DESTDIR/usr/lib" \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
        -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lldb" \
        -DCMAKE_C_FLAGS="-isystem $DESTDIR/usr/include" \
        -DCMAKE_CXX_FLAGS="-isystem $DESTDIR/usr/include" \
        -DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS" \
        -DCMAKE_SHARED_LINKER_FLAGS="$LDFLAGS" \
        -DCMAKE_MODULE_LINKER_FLAGS="$LDFLAGS" \
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
        -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
        -DLLDB_ENABLE_LIBEDIT=1 \
        -DLibEdit_INCLUDE_DIRS="$DESTDIR/usr/include" \
        -DLibEdit_LIBRARIES="$DESTDIR/usr/lib/libedit.so" \
        -DLLDB_ENABLE_CURSES=1 \
        -DCURSES_NEED_NCURSES=TRUE \
        -DCURSES_LIBRARY="$DESTDIR/usr/lib/libncurses.so" \
        -DCURSES_INCLUDE_PATH="$DESTDIR/usr/include" \
        -DLLDB_ENABLE_LZMA=1 \
        -DLIBLZMA_INCLUDE_DIR="$DESTDIR/usr/include" \
        -DLIBLZMA_LIBRARY="$DESTDIR/usr/lib/liblzma.so" \
        -DLLDB_ENABLE_LIBXML2=1 \
        -DLIBXML2_INCLUDE_DIR="$DESTDIR/usr/include/libxml2" \
        -DLIBXML2_LIBRARIES="$DESTDIR/usr/lib/libxml2.so" \
        -DLLDB_ENABLE_PYTHON=1 \
        -DPython3_ROOT_DIR="$DESTDIR/usr" \
        -DPython3_EXECUTABLE="$DESTDIR/usr/bin/python3" \
        -DLLDB_ENABLE_LUA=1 \
        -DLUA_INCLUDE_DIR="$DESTDIR/usr/include" \
        -DLUA_LIBRARIES="$DESTDIR/usr/lib/liblua.a" \
        -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind" \
        -DCMAKE_INSTALL_PREFIX="$DESTDIR/usr" \
        ../llvm
fi
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
for f in bin/*; do
    cp -an "$f" "$DESTDIR/usr/bin/"
done
