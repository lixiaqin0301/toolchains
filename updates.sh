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
rm -f nvim-linux64.tar.gz nvim-linux64.tar.gz.*
for _ in {0..9}; do
    wget -c "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz" && break
    rm -f nvim-linux64.tar.gz nvim-linux64.tar.gz.*
done
if [[ -f /home/lixq/src/nvim-linux64.tar.gz ]]; then
    cd "/home/lixq/toolchains" || exit 1
    rm -rf nvim-*
    tar -xf /home/lixq/src/nvim-linux64.tar.gz
fi

sudo rm -rf /home/lixq/toolchains/github.com /tmp/t
mkdir -p /home/lixq/toolchains/github.com /tmp/t
touch /tmp/t/t.c /tmp/t/t.py /tmp/t/t.sh /tmp/t/t.lua /tmp/t/t.go
nvim /tmp/t/t.*
cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/ || exit 1
for _ in {0..9}; do
    git submodule update --init --recursive && break
done
for _ in {0..9}; do
    python3 install.py --clang-completer --system-libclang --go-completer --verbose && break
done

cd /home/lixq || exit 1
sudo rm -rf /mnt/d/toolchains.tar
tar -cf /mnt/d/toolchains.tar toolchains
