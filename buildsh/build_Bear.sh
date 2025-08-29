#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=3.1.6
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
# third_party/*/CMakeLists.txt
fmtver=11.0.2
googletestver=1.14.0
grpcver=1.49.2
nlohmannjsonver=3.11.3
spdlogver=1.14.1

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1
[[ -f /home/lixq/src/fmt-$fmtver.tar.gz ]] || exit 1
[[ -f /home/lixq/src/googletest-$googletestver.tar.gz ]] || exit 1
[[ -f /home/lixq/src/grpc-v$grpcver.tar.gz ]] || exit 1
[[ -f /home/lixq/src/json-$nlohmannjsonver.tar.gz ]] || exit 1
[[ -f /home/lixq/src/spdlog-$spdlogver.tar.gz ]] || exit 1

export PATH="/home/lixq/toolchains/cmake/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LDFLAGS="-static-libgcc -static-libstdc++"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
mkdir -p build/subprojects/Download/fmt_dependency/
cp -f /home/lixq/src/fmt-$fmtver.tar.gz build/subprojects/Download/fmt_dependency/$fmtver.tar.gz || exit 1
mkdir -p build/subprojects/Download/googletest_dependency/
cp -f /home/lixq/src/googletest-$googletestver.tar.gz build/subprojects/Download/googletest_dependency/v$googletestver.tar.gz || exit 1
n=$(awk '/ExternalProject_Add/{print FNR}' "/home/lixq/src/$name-$ver/third_party/grpc/CMakeLists.txt")
sed -i "$((n+1)),$((n+7))c\            URL\n                https://github.com/grpc/grpc/archive/refs/tags/v$grpcver.tar.gz\n            URL_HASH\n                MD5=$(md5sum /home/lixq/src/grpc-v$grpcver.tar.gz | awk '{print $1}')\n            DOWNLOAD_NO_PROGRESS\n                1" third_party/grpc/CMakeLists.txt
mkdir -p build/subprojects/Download/grpc_dependency/
cp -f /home/lixq/src/grpc-v$grpcver.tar.gz build/subprojects/Download/grpc_dependency/v$grpcver.tar.gz || exit 1
mkdir -p build/subprojects/Download/nlohmann_json_dependency/
cp -f /home/lixq/src/json-$nlohmannjsonver.tar.gz build/subprojects/Download/nlohmann_json_dependency/v$nlohmannjsonver.tar.gz || exit 1
mkdir -p build/subprojects/Download/spdlog_dependency/
cp -f /home/lixq/src/spdlog-$spdlogver.tar.gz build/subprojects/Download/spdlog_dependency/v$spdlogver.tar.gz || exit 1
mkdir -p build
cd build || exit 1
cmake -DCMAKE_INSTALL_PREFIX="$DESTDIR/usr" .. || exit 1
make -s "-j$(nproc)" || exit 1
[[ $DESTDIR == */$name ]] && rm -rf "$DESTDIR"
make -s "-j$(nproc)" install || exit 1

# git clone --depth 1 https://github.com/grpc/grpc -b v1.49.2 grpc-v1.49.2
# cd grpc-v1.49.2
# git submodule update --init
# find . -name CMakeLists.txt -exec sed -i -e '/^cmake_minimum_required/c cmake_minimum_required(VERSION 3.8)' -e '/^CMAKE_MINIMUM_REQUIRED/c CMAKE_MINIMUM_REQUIRED(VERSION 3.8)' {} \;
# cd ..
# tar -czf grpc-v1.49.2.tar.gz grpc-v1.49.2
