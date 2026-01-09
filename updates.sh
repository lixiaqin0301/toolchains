#!/bin/bash

cd "/home/lixq/toolchains" || exit 1
pwd
for _ in {0..9}; do
    git pull && break
done

sudo apt update -y
sudo apt full-upgrade -y

for d in /home/lixq/toolchains/*/.git; do
    cd "$(dirname "${d}")" || exit
    pwd
    git restore .
    git clean -fdx
    for _ in {0..9}; do
        git pull && break
    done
done
sed -i 's/print("/ngx.log(ngx.ERR, "/' /home/lixq/toolchains/LuaPanda/Debugger/LuaPanda.lua

[[ -d "/home/lixq/src" ]] || mkdir -p "/home/lixq/src"
cd "/home/lixq/src" || exit 1
rm -f nvim-linux-x86_64.tar.gz nvim-linux-x86_64.tar.gz.*
if [[ -f /home/lixq/35share-rd/src/nvim-linux-x86_64.tar.gz ]]; then
    cp /home/lixq/35share-rd/src/nvim-linux-x86_64.tar.gz .
else
    for _ in {0..9}; do
        wget -c "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz" && break
        rm -f nvim-linux-x86_64.tar.gz nvim-linux-x86_64.tar.gz.*
        sleep 1
    done
fi
if [[ -f /home/lixq/src/nvim-linux-x86_64.tar.gz ]]; then
    cd "/home/lixq/toolchains" || exit 1
    rm -rf nvim-*
    tar -xf /home/lixq/src/nvim-linux-x86_64.tar.gz
fi

sudo rm -rf /home/lixq/toolchains/github.com /tmp/t
mkdir -p /home/lixq/toolchains/github.com /tmp/t
touch /tmp/t/t.c /tmp/t/t.py /tmp/t/t.sh /tmp/t/t.lua /tmp/t/t.go
nvim /tmp/t/t.*
cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/ || exit 1
for _ in {0..9}; do
    git submodule update --init --recursive && break
done
if [[ -f /home/lixq/35share-rd/src/clangd-21.1.3-x86_64-unknown-linux-gnu.tar.bz2 ]]; then
    mkdir -p /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/clangd/cache/
    cp /home/lixq/35share-rd/src/clangd-21.1.3-x86_64-unknown-linux-gnu.tar.bz2 /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/clangd/cache/
fi
for _ in {0..9}; do
    python3 install.py --clangd-completer --clang-completer --system-libclang --go-completer --verbose && break
done

if [[ -f /mnt/d/Bear.tar ]]; then
    cd /home/lixq/toolchains/ || exit 1
    rm -rf Bear
    tar -xf /mnt/d/Bear.tar
fi

if [[ -f /mnt/d/cargo.tar ]]; then
    cd /home/lixq/toolchains/ || exit 1
    rm -rf .cargo cargo
    tar -xf /mnt/d/cargo.tar
    mv .cargo cargo
fi

if [[ -f /mnt/d/rustup.tar ]]; then
    cd /home/lixq/toolchains/ || exit 1
    rm -rf .rustup rustup
    tar -xf /mnt/d/rustup.tar
    mv .rustup rustup
fi

if [[ -d /mnt/d/ ]]; then
    cd /home/lixq || exit 1
    sudo rm -rf /mnt/d/toolchains.tar.gz
    tar -czf /mnt/d/toolchains.tar.gz toolchains
fi
