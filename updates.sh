#!/bin/bash

[[ -f /share-rd/lixq/src/nvim-linux-x86_64.tar.gz ]] || exit 1
[[ -f /mnt/d/t/go.tar ]] || exit 1
[[ -f /mnt/d/t/Bear.tar ]] || exit 1
[[ -f /mnt/d/t/cargo.tar ]] || exit 1
[[ -f /mnt/d/t/rustup.tar ]] || exit 1

sudo rm -rf /tmp/t /home/lixq/toolchains/github.com /home/lixq/toolchains/go /home/lixq/toolchains/Bear /home/lixq/toolchains/cargo /home/lixq/toolchains/rustup /share-rd/lixq/src/toolchains.tar.gz
sudo chown -R lixq:lixq /home/lixq/toolchains /share-rd/lixq/src/
sudo apt update -y
sudo apt full-upgrade -y

cd /home/lixq/toolchains || exit 1
pwd
git pull

for d in /home/lixq/toolchains/*/.git; do
    cd "$(dirname "${d}")" || exit
    pwd
    git restore .
    git clean -fdx
    git pull
done

# wget "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"
cd /home/lixq/toolchains || exit 1
rm -rf nvim-*
tar -xf /share-rd/lixq/src/nvim-linux-x86_64.tar.gz

cd /home/lixq/toolchains || exit 1
rm -rf github.com
mkdir -p github.com /tmp/t

touch /tmp/t/t.c /tmp/t/t.py /tmp/t/t.sh /tmp/t/t.lua /tmp/t/t.go
nvim /tmp/t/t.*
cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/ || exit 1
git submodule update --init --recursive
if [[ -f /share-rd/lixq/src/clangd-21.1.3-x86_64-unknown-linux-gnu.tar.bz2 ]]; then
    mkdir -p /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/clangd/cache/
    cp /share-rd/lixq/src/clangd-21.1.3-x86_64-unknown-linux-gnu.tar.bz2 /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/clangd/cache/
fi
python3 install.py --clangd-completer --clang-completer --system-libclang --go-completer --verbose

cd /home/lixq/toolchains || exit 1
rm -rf go Bear cargo rustup
tar -xf /mnt/d/t/go.tar
tar -xf /mnt/d/t/Bear.tar
tar -xf /mnt/d/t/cargo.tar
tar -xf /mnt/d/t/rustup.tar

cd /home/lixq || exit 1
sudo chown -R root:root /home/lixq/toolchains /share-rd/lixq/src/
sudo tar -czf /share-rd/lixq/src/toolchains.tar.gz toolchains
