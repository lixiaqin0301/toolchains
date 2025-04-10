#!/bin/bash

# shellcheck disable=SC1091
export PATH=/home/lixq/toolchains/Miniforge3/bin:/home/lixq/toolchains/cmake/bin:/home/lixq/toolchains/golang/bin:/home/lixq/toolchains/go/bin:/home/lixq/toolchains/llvm/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
if [[ -x /opt/rh/devtoolset-11/enable ]]; then
    . /opt/rh/devtoolset-11/enable
fi

function recover() {
    cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/cpp || exit 1
    [[ -f CMakeLists.txt.bak ]] && mv CMakeLists.txt.bak CMakeLists.txt
    cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd || exit 1
    [[ -f build.py.bak ]] && mv build.py.bak build.py
}
trap recover EXIT

if [[ ! -d /home/lixq/toolchains/github.com/Valloric/YouCompleteMe ]]; then
    echo "cd /home/lixq/toolchains/github.com/Valloric"
    echo "git clone https://github.com/ycm-core/YouCompleteMe.git"
    echo "cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe"
    echo "git submodule update --init --recursive"
    exit 1
fi

cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/cpp || exit 1
cp CMakeLists.txt CMakeLists.txt.bak
sed -i '/include( FetchContent )/,/FetchContent_MakeAvailable( absl )/c\  add_subdirectory( absl )' CMakeLists.txt
cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd || exit 1
cp build.py build.py.bak
sed -i '/if not OnWindows() and os.geteuid() == 0:/,/This script should not be run with root privileges./d' build.py

cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe || exit 1

export CPATH=/home/lixq/toolchains/llvm/include
export LIBRARY_PATH=/home/lixq/toolchains/llvm/lib
export LD_LIBRARY_PATH=/home/lixq/toolchains/llvm/lib
export LD_RUN_PATH=/home/lixq/toolchains/llvm/lib
export LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/llvm/lib:/home/lixq/toolchains/Miniforge3/lib"
if [[ -f /home/lixq/35share-rd/src/clangd-19.1.0-x86_64-unknown-linux-gnu.tar.bz2 ]]; then
    mkdir -p /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/clangd/cache/
    cp /home/lixq/35share-rd/src/clangd-19.1.0-x86_64-unknown-linux-gnu.tar.bz2 /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/clangd/cache/
fi
python3 install.py --clangd-completer --clang-completer --system-libclang --go-completer --verbose
