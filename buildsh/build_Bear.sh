#!/bin/bash

name=Bear
ver=3.1.6
srcpath=/home/lixq/src/Bear-${ver}.tar.gz
# third_party/*/CMakeLists.txt
fmtver=11.0.2
googletestver=1.14.0
grpcver=1.49.2
nlohmannjsonver=3.11.3
spdlogver=1.14.1
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/src/grpc-v${grpcver}.tar.gz ]]; then
    echo "git clone --depth 1 https://github.com/grpc/grpc -b v${grpcver} grpc-v${grpcver}"
    echo "cd grpc-v${grpcver} && git submodule update --init"
    for f in examples/android/helloworld/app/CMakeLists.txt \
             third_party/boringssl-with-bazel/src/util/ar/testdata/sample/CMakeLists.txt \
             third_party/boringssl-with-bazel/src/third_party/googletest/CMakeLists.txt \
             third_party/protobuf/examples/CMakeLists.txt third_party/libuv/CMakeLists.txt \
             third_party/zlib/CMakeLists.txt \
             src/android/test/interop/app/CMakeLists.txt; do
        echo -n "sed -i '/^cmake_minimum_required/c cmake_minimum_required(VERSION 3.8)' $f; "
    done
    echo "sed -i '/^CMAKE_MINIMUM_REQUIRED/c CMAKE_MINIMUM_REQUIRED (VERSION 3.8)' third_party/cares/cares/CMakeLists.txt"
    echo "cd .."
    echo "tar -czf grpc-v${grpcver}.tar.gz grpc-v${grpcver}"
    exit 1
fi

if [[ "$DESTDIR" == */${name} ]]; then
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" gcc
    export PATH="/home/lixq/toolchains/cmake/usr/bin:$PATH"
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
fi

cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf ${srcpath} || exit 1
cd /home/lixq/src/${name}-${ver} || exit 1
mkdir -p build/subprojects/Download/fmt_dependency/
cp -f /home/lixq/src/fmt-${fmtver}.tar.gz build/subprojects/Download/fmt_dependency/${fmtver}.tar.gz || exit 1
mkdir -p build/subprojects/Download/googletest_dependency/
cp -f /home/lixq/src/googletest-${googletestver}.tar.gz build/subprojects/Download/googletest_dependency/v${googletestver}.tar.gz || exit 1
n=$(awk '/ExternalProject_Add/{print FNR}' /home/lixq/src/${name}-${ver}/third_party/grpc/CMakeLists.txt)
sed -i "$((n+1)),$((n+7))c\            URL\n                https://github.com/grpc/grpc/archive/refs/tags/v${grpcver}.tar.gz\n            URL_HASH\n                MD5=$(md5sum /home/lixq/src/grpc-v${grpcver}.tar.gz | awk '{print $1}')\n            DOWNLOAD_NO_PROGRESS\n                1" third_party/grpc/CMakeLists.txt
mkdir -p build/subprojects/Download/grpc_dependency/
cp -f /home/lixq/src/grpc-v${grpcver}.tar.gz build/subprojects/Download/grpc_dependency/v${grpcver}.tar.gz || exit 1
mkdir -p build/subprojects/Download/nlohmann_json_dependency/
cp -f /home/lixq/src/json-${nlohmannjsonver}.tar.gz build/subprojects/Download/nlohmann_json_dependency/v${nlohmannjsonver}.tar.gz || exit 1
mkdir -p build/subprojects/Download/spdlog_dependency/
cp -f /home/lixq/src/spdlog-${spdlogver}.tar.gz build/subprojects/Download/spdlog_dependency/v${spdlogver}.tar.gz || exit 1
mkdir -p build
cd build || exit 1
cmake -DCMAKE_INSTALL_PREFIX="$DESTDIR"/usr .. || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install || exit 1
