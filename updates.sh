#!/bin/bash

if [[ -d /home/lixq/toolchains ]]; then
    tdir=/home/lixq/toolchains
    sdir=/home/lixq/src
    nvimtar=nvim-linux64.tar.gz
    [[ -d "$sdir" ]] || mkdir -p "$sdir"
else
    tdir=~/toolchains
    sdir=~/src
    nvimtar=nvim-macos.tar.gz
    [[ -d "$sdir" ]] || mkdir -p "$sdir"
    cp $tdir/SpaceVim.d/autoload/config.vim $sdir/
    cd $tdir || exit 1
    git restore .
fi

function recover() {
    [[ -f $sdir/config.vim ]] && mv $sdir/config.vim SpaceVim.d/autoload/config.vim
    [[ -f $sdir/ycmd_cpp_CMakeLists.txt ]] && mv $sdir/ycmd_cpp_CMakeLists.txt $tdir/github.com/Valloric/YouCompleteMe/third_party/ycmd/cpp/CMakeLists.txt
}
trap recover EXIT

cd "$sdir" || exit 1
rm -f nightly nightly.*
until wget https://hub.nuaa.cf/neovim/neovim/releases/tag/nightly; do
    rm -f nightly nightly.*
done
expnvimsha256=$(grep -oE "[[:xdigit:]]{64}[[:space:]]*$nvimtar" nightly | awk '{print $1}' | head -n 1)
realnvimsha256=
if [[ -f "$nvimtar" ]]; then
    realnvimsha256=$(sha256sum $nvimtar | awk '{print $1}')
fi
if [[ "$realnvimsha256" != "$expnvimsha256" ]]; then
    rm -f $nvimtar $nvimtar.*
    until wget -c https://hub.njuu.cf/neovim/neovim/releases/download/nightly/$nvimtar; do
        sleep 1
    done
    cd $tdir || exit 1
    rm -rf nvim-*
    tar -xf $sdir/$nvimtar
fi

cd $tdir || exit 1
pwd
until git pull; do
    sleep 1
done

find $tdir/*/ -name .git | while read -r d; do
    cd "$(dirname "$d")" || continue
    pwd
    git remote set-url origin "$(git remote -v | awk '{print $2}' | head -n 1 | sed 's;github.com;hub.njuu.cf;')"
    if git branch | grep detache; then
        git checkout "$(git branch -la | awk '{print $1}' | grep -E 'remotes/origin/(master|hg|main)' | head -n 1 | cut -b 16-)"
    fi
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
cp $tdir/github.com/Valloric/YouCompleteMe/third_party/ycmd/cpp/CMakeLists.txt $sdir/ycmd_cpp_CMakeLists.txt
sed -i 's;github.com;hub.njuu.cf;' third_party/ycmd/cpp/CMakeLists.txt
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
