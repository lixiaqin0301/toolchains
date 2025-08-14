#!/bin/bash

ver=20.1.8

if [[ ! -f /home/lixq/35share-rd/src/llvm-project-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/llvm-project-${ver}.src.tar.xz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" \
    /home/lixq/toolchains/gcc \
    /home/lixq/toolchains/binutils \
    /home/lixq/toolchains/Miniforge3 \
    /home/lixq/toolchains/lua \
    /home/lixq/toolchains/swig
export PATH=/home/lixq/toolchains/cmake/bin:$PATH
[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src/
cd /home/lixq/src/ || exit 1
rm -rf llvm-project-*
tar -xf /home/lixq/35share-rd/src/llvm-project-${ver}.src.tar.xz
mkdir /home/lixq/src/llvm-project-${ver}.src/build || exit 1
cd /home/lixq/src/llvm-project-${ver}.src/build || exit 1

cmake -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
    -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lldb" \
    -DLLDB_ENABLE_LIBEDIT=1 \
    -DLLDB_ENABLE_CURSES=1 \
    -DLLDB_ENABLE_LZMA=1 \
    -DLLDB_ENABLE_LIBXML2=1 \
    -DLLDB_ENABLE_PYTHON=1 \
    -DLLDB_ENABLE_LUA=1 \
    -DLUA_INCLUDE_DIR="/home/lixq/toolchains/lua/include" \
    -DLUA_LIBRARIES="/home/lixq/toolchains/lua/lib/liblua.a" \
    -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind" \
    -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/llvm-${ver} -G "Unix Makefiles" ../llvm
make -j "$(nproc)" || exit 1
rm -rf /home/lixq/toolchains/llvm-${ver}
make install || exit 1

if [[ -d /home/lixq/toolchains/llvm-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f llvm
    ln -s llvm-${ver} llvm
fi
