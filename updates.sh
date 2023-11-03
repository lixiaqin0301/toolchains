#!/bin/bash

if [[ -d /home/lixq/toolchains ]]; then
    tdir=/home/lixq/toolchains
    cd $tdir || exit 1
    rm nvim-*.tar.gz
    until wget -c https://hub.njuu.cf/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz; do
        sleep 1
    done
else
    tdir=~/toolchains
    cd $tdir || exit 1
    rm nvim-*.tar.gz
    until wget -c https://hub.njuu.cf/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz; do
        sleep 1
    done
    cp SpaceVim.d/autoload/config.vim ~/Downloads/config.vim
    git restore .
fi
cd $tdir || exit 1
if [[ -f nvim-*.tar.gz ]]; do
    rm -rf nvim-*/
    tar -xf nvim-*.tar.gz
done
pwd
until git pull; do
    sleep 1
done
if [[ ! -d /home/lixq/toolchains ]]; then
    cp ~/Downloads/config.vim $tdir/SpaceVim.d/autoload/config.vim
fi

for d in $tdir/github.com/*/*/; do
    cd $d || continue
    pwd
    until git pull; do
        sleep 1
    done
    until git submodule update --init --recursive; do
        sleep 1
    done
done

cd ~ || exit 1
if command -v brew; then
    until brew update; do
        sleep 1
    done
    until brew upgrade; do
        sleep 1
    done
elif command -v apt; then
    sudo apt update -y
    sudo apt full-upgrade -y
elif command -v yum; then
    yum clean all
    yum update -y --skip-broken
    yum upgrade -y --skip-broken
fi

cd $tdir/github.com/Valloric/YouCompleteMe || exit 1
if [[ -d /home/lixq/toolchains/llvm/include ]]; then
    export CPATH=/home/lixq/toolchains/llvm/include
    export LIBRARY_PATH=/home/lixq/toolchains/llvm/lib
    export LD_LIBRARY_PATH=/home/lixq/toolchains/llvm/lib
    export LD_RUN_PATH=/home/lixq/toolchains/llvm/lib
    export LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/llvm/lib:/home/lixq/toolchains/Anaconda3/lib"
fi
until python3 install.py --system-libclang --clang-completer; do
    sleep 1
done
if [[ -d /usr/local/Cellar/llvm ]]; then
    cd $tdir/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/clang/lib || exit 1
    for f in /usr/local/Cellar/llvm/*/lib/libclang.dylib; do
        ln -sf "$f" .
        break
    done
fi
