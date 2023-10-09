#!/bin/bash

for d in /home/lixq/toolchains/FlameGraph/ /home/lixq/toolchains/github.com/*/*/; do
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
sudo apt update -y
sudo apt upgrade -y
#yum makecache || exit 1
#yum update -y --skip-broken || exit 1
#yum upgrade -y --skip-broken || exit 1
#rm -rvf /tmp/*
#reboot

cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe || exit 1
export CPATH=/home/lixq/toolchains/llvm/include
export LIBRARY_PATH=/home/lixq/toolchains/llvm/lib
export LD_LIBRARY_PATH=/home/lixq/toolchains/llvm/lib
export LD_RUN_PATH=/home/lixq/toolchains/llvm/lib
export LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/llvm/lib:/home/lixq/toolchains/Anaconda3/lib"
until python3 install.py --system-libclang --clang-completer --cs-completer --rust-completer --java-completer --ts-completer; do
    sleep 1
done
