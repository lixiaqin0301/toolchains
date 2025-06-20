#!/bin/bash

ver=20.1.7

if [[ ! -f /home/lixq/35share-rd/src/llvm-project-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/llvm-project-${ver}.src.tar.xz"
    exit 1
fi

export PATH="/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/binutils/bin:/home/lixq/toolchains/Miniforge3/bin:/home/lixq/toolchains/lua/bin:/home/lixq/toolchains/swig/bin:/home/lixq/toolchains/cmake/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
export PKG_CONFIG_PATH="/home/lixq/toolchains/Miniforge3/lib/pkgconfig"
export CC="/home/lixq/toolchains/gcc/bin/gcc"
export CXX="/home/lixq/toolchains/gcc/bin/g++"
export CCAS="/home/lixq/toolchains/gcc/bin/gcc"
export CPP="/home/lixq/toolchains/gcc/bin/cpp"
export CFLAGS="-I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/Miniforge3/include"
export CXXFLAGS="-I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/Miniforge3/include"
export LDFLAGS="-L/home/lixq/toolchains/gcc/lib64 -L/home/lixq/toolchains/binutils/lib -L/home/lixq/toolchains/Miniforge3/lib -Wl,-rpath=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/binutils/lib:/home/lixq/toolchains/Miniforge3/lib"

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src/
cd /home/lixq/src/ || exit 1
rm -rf llvm-project-*
tar -xf /home/lixq/35share-rd/src/llvm-project-${ver}.src.tar.xz
mkdir /home/lixq/src/llvm-project-${ver}.src/build || exit 1
cd /home/lixq/src/llvm-project-${ver}.src/build || exit 1

cmake -DCMAKE_BUILD_TYPE=Release \
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
make || exit 1
rm -rf /home/lixq/toolchains/llvm-${ver}
make install || exit 1

if [[ -d /home/lixq/toolchains/llvm-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f llvm
    ln -s llvm-${ver} llvm
fi
