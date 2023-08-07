#!/bin/bash

ver=16.0.6

export PATH=/home/lixq/toolchains/cmake/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/src/llvm-${ver}.src.tar.xz ]]; then
    echo "wget https://github.com/llvm/llvm-project/releases/download/llvmorg-${ver}/llvm-${ver}.src.tar.xz -O /home/lixq/src/llvm-${ver}.src.tar.xz"
    exit 1
fi

if [[ ! -f /home/lixq/src/clang-${ver}.src.tar.xz ]]; then
    echo "wget https://github.com/llvm/llvm-project/releases/download/llvmorg-${ver}/clang-${ver}.src.tar.xz -O /home/lixq/src/clang-${ver}.src.tar.xz"
    exit 1
fi

if [[ ! -f  /home/lixq/src/cmake-${ver}.src.tar.xz ]]; then
    echo "wget https://github.com/llvm/llvm-project/releases/download/llvmorg-${ver}/cmake-${ver}.src.tar.xz -O /home/lixq/src/cmake-${ver}.src.tar.xz"
    exit 1
fi

if [[ ! -f /home/lixq/src/third-party-${ver}.src.tar.xz ]]; then
    echo "wget https://github.com/llvm/llvm-project/releases/download/llvmorg-${ver}/third-party-${ver}.src.tar.xz -O /home/lixq/src/third-party-${ver}.src.tar.xz"
    exit 1
fi

cd /home/lixq/src || exit 1
rm -rf cmake-${ver}.src cmake
tar -xf cmake-${ver}.src.tar.xz
mv cmake-${ver}.src cmake

cd /home/lixq/src || exit 1
rm -rf third-party-${ver}.src third-party
tar -xf third-party-${ver}.src.tar.xz
mv third-party-${ver}.src third-party

cd /home/lixq/src || exit 1
rm -rf llvm-${ver}.src llvm
tar -xf llvm-${ver}.src.tar.xz
mv llvm-${ver}.src llvm

cd /home/lixq/src/llvm/tools || exit 1
tar -xf /home/lixq/src/clang-${ver}.src.tar.xz
mv clang-${ver}.src clang

mkdir /home/lixq/src/llvm/build
cd /home/lixq/src/llvm/build || exit 1

cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/llvm-${ver} -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_BUILD_LLVM_DYLIB=1 -DLLVM_INCLUDE_BENCHMARKS=0 .. || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/llvm-${ver}
make install || exit 1

if [[ -d /home/lixq/toolchains/llvm-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f llvm
    ln -s llvm-${ver} llvm
fi
