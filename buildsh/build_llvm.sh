#!/bin/bash

ver=20.1.5

export PATH=/home/lixq/toolchains/cmake/bin:/home/lixq/toolchains/Miniforge3/bin:/home/lixq/toolchains/lua/bin:/home/lixq/toolchains/swig/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

export PKG_CONFIG_PATH="/home/lixq/toolchains/Miniforge3/lib/pkgconfig"
export CPATH="/home/lixq/toolchains/Miniforge3/include"
export LIBRARY_PATH="/home/lixq/toolchains/Miniforge3/lib"
export LD_RUN_PATH="/home/lixq/toolchains/Miniforge3/lib"
export LD_LIBRARY_PATH="/home/lixq/toolchains/Miniforge3/lib"
export LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/Miniforge3/lib"

function recover() {
    rm -f /usr/lib64/libstdc++.so /usr/lib/libstdc++.so
    for f in /opt/rh/devtoolset-11/root/usr/lib/gcc/x86_64-redhat-linux/11/libstdc++.a \
        /opt/rh/devtoolset-11/root/usr/lib/gcc/x86_64-redhat-linux/11/libstdc++.so; do
        [[ -f ${f}.bak ]] && mv ${f}.bak ${f}
    done
}
trap recover EXIT
mv /opt/rh/devtoolset-11/root/usr/lib/gcc/x86_64-redhat-linux/11/libstdc++.a /opt/rh/devtoolset-11/root/usr/lib/gcc/x86_64-redhat-linux/11/libstdc++.a.bak
ln -sf /home/lixq/toolchains/gcc/lib64/libstdc++.a /opt/rh/devtoolset-11/root/usr/lib/gcc/x86_64-redhat-linux/11/libstdc++.a
rm -f /usr/lib64/libstdc++.so /usr/lib/libstdc++.so
ln -sf /home/lixq/toolchains/Miniforge3/lib/libstdc++.so /usr/lib64/libstdc++.so
ln -sf /home/lixq/toolchains/Miniforge3/lib/libstdc++.so /usr/lib/libstdc++.so
cp /opt/rh/devtoolset-11/root/usr/lib/gcc/x86_64-redhat-linux/11/libstdc++.so /opt/rh/devtoolset-11/root/usr/lib/gcc/x86_64-redhat-linux/11/libstdc++.so.bak
sed -i 's/libstdc++.so.6/libstdc++.so/' /opt/rh/devtoolset-11/root/usr/lib/gcc/x86_64-redhat-linux/11/libstdc++.so

need_exit=no
if [[ ! -f /home/lixq/35share-rd/src/llvm-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/llvm-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/clang-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/clang-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f  /home/lixq/35share-rd/src/cmake-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/cmake-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/third-party-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/third-party-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/compiler-rt-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/compiler-rt-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/runtimes-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/runtimes-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/lldb-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/lldb-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/clang-tools-extra-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/clang-tools-extra-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/libcxx-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/libcxx-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/libcxxabi-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/libcxxabi-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/libunwind-${ver}.src.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/LLVM%20${ver}/libunwind-${ver}.src.tar.xz"
    need_exit=yes
fi
if [[ "$need_exit" == yes ]]; then
    exit 1
fi

rm -rf /home/lixq/src/llvm-project
mkdir -p /home/lixq/src/llvm-project

cd /home/lixq/src/llvm-project || exit 1
tar -xf /home/lixq/35share-rd/src/llvm-${ver}.src.tar.xz
mv llvm-${ver}.src llvm
tar -xf /home/lixq/35share-rd/src/clang-${ver}.src.tar.xz
mv clang-${ver}.src clang
tar -xf /home/lixq/35share-rd/src/cmake-${ver}.src.tar.xz
mv cmake-${ver}.src cmake
tar -xf /home/lixq/35share-rd/src/third-party-${ver}.src.tar.xz
mv third-party-${ver}.src third-party
tar -xf /home/lixq/35share-rd/src/compiler-rt-${ver}.src.tar.xz
mv compiler-rt-${ver}.src compiler-rt
tar -xf /home/lixq/35share-rd/src/runtimes-${ver}.src.tar.xz
mv runtimes-${ver}.src runtimes
tar -xf /home/lixq/35share-rd/src/clang-tools-extra-${ver}.src.tar.xz
mv clang-tools-extra-${ver}.src clang-tools-extra
tar -xf /home/lixq/35share-rd/src/lldb-${ver}.src.tar.xz
mv lldb-${ver}.src lldb
tar -xf /home/lixq/35share-rd/src/libcxx-${ver}.src.tar.xz
mv libcxx-${ver}.src libcxx
tar -xf /home/lixq/35share-rd/src/libcxxabi-${ver}.src.tar.xz
mv libcxxabi-${ver}.src libcxxabi
tar -xf /home/lixq/35share-rd/src/libunwind-${ver}.src.tar.xz
mv libunwind-${ver}.src libunwind

mkdir /home/lixq/src/llvm-project/build
cd /home/lixq/src/llvm-project/build || exit 1

cmake -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lldb" \
    -DLLDB_ENABLE_LIBEDIT=1 \
    -DLLDB_ENABLE_CURSES=1 \
    -DLLDB_ENABLE_LZMA=1 \
    -DLLDB_ENABLE_LIBXML2=1 \
    -DLLDB_ENABLE_PYTHON=1 \
    -DLLDB_ENABLE_LUA=1 \
    -DLUA_INCLUDE_DIR="/home/lixq/toolchains/lua/include" \
    -DLUA_LIBRARIES="/home/lixq/toolchains/lua/lib/liblua.a" \
    -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind" \
    -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/llvm-${ver} -G "Unix Makefiles" ../llvm
make || exit 1
rm -rf /home/lixq/toolchains/llvm-${ver}
make install || exit 1

if [[ -d /home/lixq/toolchains/llvm-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f llvm
    ln -s llvm-${ver} llvm
fi
