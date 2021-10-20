#!/bin/bash

if [[ ! -f /home/lixq/toolchains/src/llvm-13.0.0.src.tar.xz ]]; then
    if ! wget https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/llvm-13.0.0.src.tar.xz -O /home/lixq/toolchains/src/llvm-13.0.0.src.tar.xz; then
        rm -f /home/lixq/toolchains/src/llvm-13.0.0.src.tar.xz*
        echo "Need /home/lixq/toolchains/src/llvm-13.0.0.src.tar.xz (https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/llvm-13.0.0.src.tar.xz)"
        exit 1
    fi
fi

if [[ ! -f /home/lixq/toolchains/src/clang-13.0.0.src.tar.xz ]]; then
    if ! wget https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/clang-13.0.0.src.tar.xz -O /home/lixq/toolchains/src/clang-13.0.0.src.tar.xz; then
        rm -f /home/lixq/toolchains/src/clang-13.0.0.src.tar.xz*
        echo "Need /home/lixq/toolchains/src/llvm-13.0.0.src.tar.xz (https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/clang-13.0.0.src.tar.xz)"
        exit 1
    fi
fi

cd /home/lixq/toolchains/src || exit 1
rm -rf llvm
tar -xvf llvm-13.0.0.src.tar.xz
mv llvm-13.0.0.src llvm

cd /home/lixq/toolchains/src/llvm/tools || exit 1
tar -xvf /home/lixq/toolchains/src/clang-13.0.0.src.tar.xz
mv clang-13.0.0.src clang

mkdir /home/lixq/toolchains/src/llvm/build
cd /home/lixq/toolchains/src/llvm/build || exit 1

rm -rf /home/lixq/toolchains/llvm-13.0.0
export CPP=/home/lixq/toolchains/gcc/bin/cpp
/home/lixq/toolchains/cmake/bin/cmake \
    -DCMAKE_C_COMPILER=/home/lixq/toolchains/gcc/bin/gcc \
    -DCMAKE_CXX_COMPILER=/home/lixq/toolchains/gcc/bin/g++ \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/llvm-13.0.0 \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    -DLLVM_BUILD_LLVM_DYLIB=1 \
    -DLLVM_OPTIMIZED_TABLEGEN=1 \
    -DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,/home/lixq/toolchains/gcc/lib64 -L/home/lixq/toolchains/gcc/lib64" \
    ..
make
make install

if [[ -d /home/lixq/toolchains/llvm-13.0.0 ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f llvm
    ln -s llvm-13.0.0 llvm
fi
