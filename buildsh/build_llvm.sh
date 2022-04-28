#!/bin/bash

ver=14.0.1

if [[ ! -f /home/lixq/src/llvm-${ver}.src.tar.xz ]]; then
    if ! wget https://github.com/llvm/llvm-project/releases/download/llvmorg-${ver}/llvm-${ver}.src.tar.xz -O /home/lixq/src/llvm-${ver}.src.tar.xz; then
        rm -f /home/lixq/src/llvm-${ver}.src.tar.xz*
        echo "Need /home/lixq/src/llvm-${ver}.src.tar.xz (https://github.com/llvm/llvm-project/releases/download/llvmorg-${ver}/llvm-${ver}.src.tar.xz)"
        exit 1
    fi
fi

if [[ ! -f /home/lixq/src/clang-${ver}.src.tar.xz ]]; then
    if ! wget https://github.com/llvm/llvm-project/releases/download/llvmorg-${ver}/clang-${ver}.src.tar.xz -O /home/lixq/src/clang-${ver}.src.tar.xz; then
        rm -f /home/lixq/src/clang-${ver}.src.tar.xz*
        echo "Need /home/lixq/src/llvm-${ver}.src.tar.xz (https://github.com/llvm/llvm-project/releases/download/llvmorg-${ver}/clang-${ver}.src.tar.xz)"
        exit 1
    fi
fi

cd /home/lixq/src || exit 1
rm -rf llvm
tar -xvf llvm-${ver}.src.tar.xz
mv llvm-${ver}.src llvm

cd /home/lixq/src/llvm/tools || exit 1
tar -xvf /home/lixq/src/clang-${ver}.src.tar.xz
mv clang-${ver}.src clang

mkdir /home/lixq/src/llvm/build
cd /home/lixq/src/llvm/build || exit 1

rm -rf /home/lixq/toolchains/llvm-${ver}
export CPP=/home/lixq/toolchains/gcc/bin/cpp
/home/lixq/toolchains/cmake/bin/cmake \
    -DCMAKE_C_COMPILER=/home/lixq/toolchains/gcc/bin/gcc \
    -DCMAKE_CXX_COMPILER=/home/lixq/toolchains/gcc/bin/g++ \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/llvm-${ver} \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    -DLLVM_BUILD_LLVM_DYLIB=1 \
    -DLLVM_INCLUDE_BENCHMARKS=0 \
    -DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,/home/lixq/toolchains/gcc/lib64 -L/home/lixq/toolchains/gcc/lib64" \
    ..
make
make install
#   -DLLVM_OPTIMIZED_TABLEGEN=1 \

if [[ -d /home/lixq/toolchains/llvm-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f llvm
    ln -s llvm-${ver} llvm
fi
