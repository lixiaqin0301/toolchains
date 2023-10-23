#!/bin/bash

find /home/lixq/toolchains/*/ -name .git -exec dirname {} \; | sort -u | while read -r d; do
    cd $d || continue
    pwd
    git restore .
    git clean -fdx
    git checkout master
    git clean -fdx
    until git pull; do
        sleep 1
    done
    until git submodule update --init --recursive; do
        sleep 1
    done
done

cd /home/lixq || exit 1
if command -v apt; then
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt full-upgrade -y
elif command -v yum; then
    yum clean all
    yum makecache
    yum update -y --skip-broken
    yum upgrade -y --skip-broken
fi

cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe || exit 1
export CPATH=/home/lixq/toolchains/llvm/include
export LIBRARY_PATH=/home/lixq/toolchains/llvm/lib
export LD_LIBRARY_PATH=/home/lixq/toolchains/llvm/lib
export LD_RUN_PATH=/home/lixq/toolchains/llvm/lib
export LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/llvm/lib:/home/lixq/toolchains/Anaconda3/lib"
until python3 install.py --system-libclang --clang-completer; do
    sleep 1
done
