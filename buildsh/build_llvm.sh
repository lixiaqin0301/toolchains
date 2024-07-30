#!/bin/bash

ver=18.1.8

export PATH=/home/lixq/toolchains/cmake/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

need_exit=no
if [[ ! -f /home/lixq/35share-rd/src/llvm-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/llvm-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/clang-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/clang-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/lldb-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/lldb-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f  /home/lixq/35share-rd/src/cmake-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/cmake-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/third-party-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/third-party-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ "$need_exit" == yes ]]; then
    exit 1
fi

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf cmake-${ver}.src cmake
tar -xf /home/lixq/35share-rd/src/cmake-${ver}.src.tar.xz
mv cmake-${ver}.src cmake

cd /home/lixq/src || exit 1
rm -rf third-party-${ver}.src third-party
tar -xf /home/lixq/35share-rd/src/third-party-${ver}.src.tar.xz
mv third-party-${ver}.src third-party

cd /home/lixq/src || exit 1
rm -rf llvm-${ver}.src llvm
tar -xf /home/lixq/35share-rd/src/llvm-${ver}.src.tar.xz
mv llvm-${ver}.src llvm

#cd /home/lixq/src/llvm/tools || exit 1
cd /home/lixq/src || exit 1
tar -xf /home/lixq/35share-rd/src/clang-${ver}.src.tar.xz
mv clang-${ver}.src clang

#cd /home/lixq/src/llvm/tools || exit 1
cd /home/lixq/src || exit 1
tar -xf /home/lixq/35share-rd/src/lldb-${ver}.src.tar.xz
mv lldb-${ver}.src lldb

mkdir /home/lixq/src/llvm/build
cd /home/lixq/src/llvm/build || exit 1

#cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/llvm-${ver} -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_BUILD_LLVM_DYLIB=1 -DLLVM_INCLUDE_BENCHMARKS=0 .. || exit 1
cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/llvm-${ver} -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_BUILD_LLVM_DYLIB=1 -DLLVM_INCLUDE_BENCHMARKS=0 -DLLVM_ENABLE_PROJECTS="clang;lldb" .. || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/llvm-${ver}
make install || exit 1

if [[ -d /home/lixq/toolchains/llvm-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f llvm
    ln -s llvm-${ver} llvm
fi
