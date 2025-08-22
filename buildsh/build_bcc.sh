#!/bin/bash

ver=0.35.0
DESTDIR=/home/lixq/toolchains/bcc-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/src/bcc-src-with-submodule-${ver}.tar.gz ]]; then
    echo "wget https://github.com/iovisor/bcc/releases/download/v${ver}/bcc-src-with-submodule.tar.gz -O bcc-src-with-submodule-${ver}.tar.gz"
    exit 1
fi

function recover() {
    rm -f /home/lixq/toolchains/glibc/lib64/libdl.so
    rm -f /home/lixq/toolchains/glibc/lib64/libm.so
}
trap recover EXIT

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" gcc glibc bzip2 elfutils openssl Python
export PATH="/home/lixq/toolchains/cmake/bin:/home/lixq/toolchains/netperf/usr/local/bin:$PATH"
cd /home/lixq/toolchains/glibc/lib64 || exit 1
ln -s libdl.so.2 libdl.so
cp ../usr/lib64/libm.so .
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf bcc
tar -xf /home/lixq/src/bcc-src-with-submodule-${ver}.tar.gz
cd /home/lixq/src/bcc || exit 1
sed -i "1a set(REVISION \"${ver}\")" cmake/version.cmake
sed -i 's/ -bgd / -bg /' src/lua/CMakeLists.txt
mkdir bcc-build
cd /home/lixq/src/bcc/bcc-build || exit 1
cmake .. -DCMAKE_INSTALL_PREFIX="${DESTDIR}" \
    -DCMAKE_INCLUDE_PATH=/home/lixq/toolchains/glibc/usr/include \
    -DCMAKE_LIBRARY_PATH=/home/lixq/toolchains/glibc/lib64 \
    -DLibEdit_INCLUDE_DIRS=/home/lixq/toolchains/libedit/include \
    -DLibEdit_LIBRARIES=/home/lixq/toolchains/libedit/lib/libedit.a \
    -DZLIB_ROOT=/home/lixq/toolchains/zlib \
    -DLIBXML2_INCLUDE_DIR=/home/lixq/toolchains/libxml2/include/libxml2 \
    -DLIBXML2_LIBRARY=/home/lixq/toolchains/libxml2/lib/libxml2.a \
    -DENABLE_LLVM_SHARED=0 -DLLVM_ROOT=/home/lixq/toolchains/llvm \
    -DBISON_ROOT=/home/lixq/toolchains/bison \
    -DFLEX_ROOT=/home/lixq/toolchains/flex \
    -DLibElf_ROOT=/home/lixq/toolchains/elfutils \
    -DLibDebuginfod_ROOT=/home/lixq/toolchains/elfutils \
    -DLibLzma_ROOT=/home/lixq/toolchains/xz \
    -DLuaJIT_ROOT=/home/lixq/toolchains/LuaJIT \
    -DCMAKE_USE_LIBBPF_PACKAGE=1 -DLibBpf_ROOT=/home/lixq/toolchains/libbpf/usr
make -s -j"$(nproc)" || exit 1
rm -rf "${DESTDIR}"
make install || exit 1
cd /home/lixq/src/bcc/bcc-build/src/python/bcc-python3 || exit 1
/home/lixq/toolchains/Python/bin/python3 setup.py install
cd "${DESTDIR}" || exit 1
if [[ "${DESTDIR}" == "/home/lixq/toolchains/bcc-${ver}" ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f bcc
    ln -s bcc-${ver} bcc
fi
