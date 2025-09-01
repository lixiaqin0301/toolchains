#!/bin/bash

function recover() {
    cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/cpp || exit 1
    [[ -f CMakeLists.txt.bak ]] && mv CMakeLists.txt.bak CMakeLists.txt
    cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd || exit 1
    [[ -f build.py.bak ]] && mv build.py.bak build.py
}
trap recover EXIT

cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/cpp || exit 1
cp CMakeLists.txt CMakeLists.txt.bak
sed -i '/include( FetchContent )/,/FetchContent_MakeAvailable( absl )/c\  add_subdirectory( absl )' CMakeLists.txt
cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd || exit 1
cp build.py build.py.bak
sed -i '/if not OnWindows() and os.geteuid() == 0:/,/This script should not be run with root privileges./d' build.py

cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe || exit 1
export PATH="/home/lixq/toolchains/cmake/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/home/lixq/toolchains/golang/bin:/home/lixq/toolchains/llvm/usr/bin:$PATH"
export LDFLAGS="-static-libgcc -static-libstdc++ -Wl,-rpath,/home/lixq/toolchains/llvm/usr/lib"
if [[ -f /home/lixq/src/clangd-19.1.0-x86_64-unknown-linux-gnu.tar.bz2 ]]; then
    mkdir -p /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/clangd/cache/
    cp /home/lixq/src/clangd-19.1.0-x86_64-unknown-linux-gnu.tar.bz2 /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/third_party/clangd/cache/
fi
pip3 install neovim
python3 install.py --clangd-completer --clang-completer --system-libclang --go-completer --verbose
