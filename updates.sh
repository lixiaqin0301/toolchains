#!/bin/bash

function recover() {
    [[ -f ${sdir}/config.vim ]] && mv "${sdir}/config.vim" "${tdir}/SpaceVim.d/autoload/config.vim"
}
trap recover EXIT

if [[ -d /home/lixq/toolchains ]]; then
    tdir=/home/lixq/toolchains
    sdir=/home/lixq/src
    [[ -d "${sdir}" ]] || mkdir -p "${sdir}"
    cd "${sdir}" || exit 1
    rm -f nvim-linux64.tar.gz nvim-linux64.tar.gz.*
    #until wget -T 10 -c "https://github.com/neovim/neovim-releases/releases/download/nightly/nvim-linux64.tar.gz"; do
    until wget -T 10 -c "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz"; do
        sleep 1
    done
    cd "${tdir}" || exit 1
    rm -rf nvim-*
    tar -xf "${sdir}/nvim-linux64.tar.gz"
else
    tdir=~/toolchains
    sdir=~/src
    [[ -d "${sdir}" ]] || mkdir -p "${sdir}"
    cp "${tdir}/SpaceVim.d/autoload/config.vim" "${sdir}"
    cd "${tdir}" || exit 1
    git restore .
    cd "${sdir}" || exit 1
    rm -f nvim-macos-x86_64.tar.gz nvim-macos-x86_64.tar.gz.*
    until wget -T 10 -c "https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-x86_64.tar.gz"; do
        sleep 1
    done
    cd "${tdir}" || exit 1
    rm -rf nvim-*
    tar -xf "${sdir}/nvim-macos-x86_64.tar.gz"
fi

cd "${sdir}" || exit 1
if [[ -d /home/lixq/src/neovim ]]; then
    cd /home/lixq/src/neovim || exit 1
    git restore .
    until git pull; do
        sleep 1
    done
    make install
fi

cd "${tdir}" || exit 1
pwd
until git pull; do
    sleep 1
done

while read -r d; do
    cd "$(dirname "${d}")" || continue
    pwd
    git checkout "$(git branch -la | awk '{print $1}' | grep -E 'remotes/origin/(master|hg|main)' | head -n 1 | cut -b 16- || true)"
    until git pull; do
        sleep 1
    done
    until git submodule update --init --recursive; do
        sleep 1
    done
done < <(find "${tdir}"/*/ -name .git || true)

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

if command -v rustup; then
    rustup update
fi

cd "${tdir}/github.com/Valloric/YouCompleteMe" || exit 1
if [[ -d /home/lixq/toolchains/llvm/include ]]; then
    export CPATH=/home/lixq/toolchains/llvm/include
    export LIBRARY_PATH=/home/lixq/toolchains/llvm/lib
    export LD_LIBRARY_PATH=/home/lixq/toolchains/llvm/lib
    export LD_RUN_PATH=/home/lixq/toolchains/llvm/lib
    export LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/llvm/lib:/home/lixq/toolchains/Anaconda3/lib"
fi
until python3 install.py --system-libclang --clang-completer --go-completer --verbose; do
    sleep 1
done
if [[ -d /usr/local/Cellar/llvm ]]; then
    cd "${tdir}/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/clang/lib" || exit 1
    for f in /usr/local/Cellar/llvm/*/lib/libclang.dylib; do
        ln -sf "${f}" .
        break
    done
fi
