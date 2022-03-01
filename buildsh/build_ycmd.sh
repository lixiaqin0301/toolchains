#!/bin/bash

[[ -d /home/lixq/toolchains/github.com/Valloric ]] || mkdir -p /home/lixq/toolchains/github.com/Valloric

if [[ ! -d /home/lixq/toolchains/github.com/Valloric/YouCompleteMe ]]; then
    cd /home/lixq/toolchains/github.com/Valloric || exit 1
    if ! git clone https://github.com/ycm-core/YouCompleteMe.git; then
        echo "Need /home/lixq/toolchains/github.com/Valloric/YouCompleteMe"
        exit 1
    fi
fi

cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe || exit 1

git submodule update --init --recursive

export PATH=/home/lixq/toolchains/cmake/bin:/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/llvm/bin:$PATH
export CC=/home/lixq/toolchains/gcc/bin/gcc
export CXX=/home/lixq/toolchains/gcc/bin/g++
export CPP=/home/lixq/toolchains/gcc/bin/cpp
export LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/llvm/lib
export LD_LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/llvm/lib
export LD_RUN_PATH=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/llvm/lib
python3 install.py --clang-completer --system-libclang
