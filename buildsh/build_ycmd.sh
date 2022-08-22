#!/bin/bash

trap recover EXIT
function recover() {
    cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/cpp || exit 1
    [[ -f CMakeLists.txt.bak ]] && mv CMakeLists.txt.bak CMakeLists.txt
    cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd || exit 1
    [[ -f build.py.bak ]] && mv build.py.bak build.py
}

[[ -d /home/lixq/toolchains/github.com/Valloric ]] || mkdir -p /home/lixq/toolchains/github.com/Valloric

if [[ ! -d /home/lixq/toolchains/github.com/Valloric/YouCompleteMe ]]; then
    cd /home/lixq/toolchains/github.com/Valloric || exit 1
    if ! git clone https://github.com/ycm-core/YouCompleteMe.git; then
        echo "Need /home/lixq/toolchains/github.com/Valloric/YouCompleteMe"
        exit 1
    fi
    git submodule update --init --recursive
fi

cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd/cpp || exit 1
cp CMakeLists.txt CMakeLists.txt.bak
sed -i '/include( FetchContent )/,/add_subdirectory( absl )/c\  add_subdirectory( absl )' CMakeLists.txt
cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe/third_party/ycmd || exit 1
cp build.py build.py.bak
sed -i '/if not OnWindows() and os.geteuid() == 0:/,/This script should not be run with root privileges./d' build.py

cd /home/lixq/toolchains/github.com/Valloric/YouCompleteMe || exit 1

export PATH=/home/lixq/toolchains/cmake/bin:/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/llvm/bin:$PATH
export CC=/home/lixq/toolchains/gcc/bin/gcc
export CXX=/home/lixq/toolchains/gcc/bin/g++
export CPP=/home/lixq/toolchains/gcc/bin/cpp
export LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/llvm/lib
export LD_LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/llvm/lib
export LD_RUN_PATH=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/llvm/lib
export LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/llvm/lib"
python3 install.py --clang-completer --system-libclang --verbose
