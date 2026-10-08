#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=$1
DESTDIR=$2
srcpath=/share-rd/cdn_prd_cache/lixq/src/$name-project-$ver.src.tar.xz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export MANPATH=
export PCP_DIR=
export LD_LIBRARY_PATH=
export PKG_CONFIG_PATH=
export INFOPATH=
export PATH="/home/lixq/toolchains/cmake/bin:/home/lixq/toolchains/gcc/usr/bin:$DESTDIR/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib64/pkgconfig:$DESTDIR/usr/lib/pkgconfig"
export LDFLAGS="-L$DESTDIR/usr/lib64 -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/usr/lib64:$DESTDIR/usr/lib -Wl,-rpath,$DESTDIR/usr/lib64:$DESTDIR/usr/lib"

[[ -d $DESTDIR/usr/lib64 ]] || mkdir -p "$DESTDIR/usr/lib64"
cd "$DESTDIR/usr/lib64" || exit 1
for p in /home/lixq/toolchains/gcc/usr/lib64/libgcc* /home/lixq/toolchains/gcc/usr/lib64/libstdc++.s*[0-9o]; do
    [[ -e $p ]] || continue
    [[ -f $(basename "$p") ]] && continue
    if [[ -L $p ]]; then
        ln -sf "$(readlink "$p")" "$(basename "$p")"
    else
        cp "$p" .
    fi
done

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src
cd /home/lixq/src
rm -rf "$name-project-$ver.src"
tar -xf "$srcpath"
# compiler-rt 的 gen_dynamic_list.py 会原地截断输出文件，
# 而 CMake 会为多个目标各生成一份调用，
# 并行构建时链接器可能读到写了一半的 version script（syntax error in VERSION script）。
# 补丁改为写临时文件后原子替换。若此补丁打不上，说明上游已改，需检查后移除。
patch -p1 -d "$name-project-$ver.src" < /home/lixq/toolchains/buildsh/llvm-gen_dynamic_list-atomic-write.patch
mkdir "$name-project-$ver.src/build"
cd "/home/lixq/src/$name-project-$ver.src/build"
cmake -G "Unix Makefiles" \
    -DCMAKE_INCLUDE_PATH="$DESTDIR/usr/include" \
    -DCMAKE_LIBRARY_PATH="$DESTDIR/usr/lib64;$DESTDIR/usr/lib" \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
    -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;lldb;bolt" \
    -DLLVM_BUILD_LLVM_DYLIB=ON \
    -DLLVM_LINK_LLVM_DYLIB=ON \
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
    -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind;openmp" \
    -DCMAKE_INSTALL_PREFIX="$DESTDIR/usr" \
    ../llvm
# clang 查找 GCC 的前缀是硬编码，用 cfg 让它改用 toolchains/gcc
mkdir -p bin
printf -- '--gcc-toolchain=/home/lixq/toolchains/gcc/usr\n' > bin/x86_64-unknown-linux-gnu.cfg
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
for f in bin/*; do
    cp -an "$f" "$DESTDIR/usr/bin/"
done
printf -- '--gcc-toolchain=/home/lixq/toolchains/gcc/usr\n' > "$DESTDIR/usr/bin/x86_64-unknown-linux-gnu.cfg"
