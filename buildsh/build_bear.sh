#!/bin/bash

export PATH=/home/lixq/toolchains/cmake/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

ver=3.0.20
fmtver=9.0.0
googletestver=1.12.1
grpcver=1.46.4
jsonver=3.10.5
spdlogver=1.10.0

if [[ ! -f /home/lixq/src/Bear-${ver}.tar.gz ]]; then
    echo "wget https://github.com/rizsotto/Bear/archive/refs/tags/${ver}.tar.gz -O /home/lixq/src/Bear-${ver}.tar.gz"
    exit 1
fi
if [[ ! -f /home/lixq/src/fmt-${fmtver}.tar.gz ]]; then
    echo "wget https://github.com/fmtlib/fmt/archive/${fmtver}.tar.gz -O /home/lixq/src/fmt-${fmtver}.tar.gz"
    exit 1
fi
if [[ ! -f /home/lixq/src/googletest-${googletestver}.tar.gz ]]; then
    echo "wget https://github.com/google/googletest/archive/release-${googletestver}.tar.gz -O /home/lixq/src/googletest-${googletestver}.tar.gz"
    exit 1
fi
if [[ ! -f /home/lixq/src/grpc-v${grpcver}.tar.gz ]]; then
    echo "git clone --depth 1 https://github.com/grpc/grpc -b v${grpcver} grpc-v${grpcver}"
    echo "cd grpc-v${grpcver} && git submodule update --init; cd .."
    echo "tar -czvf grpc-v${grpcver}.tar.gz grpc-v${grpcver}"
    exit 1
fi
if [[ ! -f /home/lixq/src/json-v${jsonver}.tar.gz ]]; then
    echo "wget https://github.com/nlohmann/json/archive/v${jsonver}.tar.gz -O /home/lixq/src/json-v${jsonver}.tar.gz"
    exit 1
fi
if [[ ! -f /home/lixq/src/spdlog-v${spdlogver}.tar.gz ]]; then
    echo "wget https://github.com/gabime/spdlog/archive/v${spdlogver}.tar.gz -O /home/lixq/src/spdlog-v${spdlogver}.tar.gz"
    exit 1
fi

cd /home/lixq/src || exit 1

rm -rf Bear-${ver}
tar -xvf Bear-${ver}.tar.gz

cd /home/lixq/src/Bear-${ver} || exit 1

mkdir -p build/subprojects/Download/fmt_dependency/
cp -f ../fmt-${fmtver}.tar.gz build/subprojects/Download/fmt_dependency/${fmtver}.tar.gz

mkdir -p build/subprojects/Download/googletest_dependency/
cp -f ../googletest-${googletestver}.tar.gz build/subprojects/Download/googletest_dependency/release-${googletestver}.tar.gz

n=$(awk '/ExternalProject_Add/{print FNR}' /home/lixq/src/Bear-${ver}/third_party/grpc/CMakeLists.txt)
sed -i "$((n+1)),$((n+7))c\            URL\n                https://github.com/grpc/grpc/archive/refs/tags/v${grpcver}.tar.gz\n            URL_HASH\n                MD5=$(md5sum /home/lixq/src/grpc-v${grpcver}.tar.gz | awk '{print $1}')\n            DOWNLOAD_NO_PROGRESS\n                1" third_party/grpc/CMakeLists.txt
mkdir -p build/subprojects/Download/grpc_dependency/
cp -f ../grpc-v${grpcver}.tar.gz build/subprojects/Download/grpc_dependency/v${grpcver}.tar.gz

mkdir -p build/subprojects/Download/nlohmann_json_dependency/
cp -f ../json-v${jsonver}.tar.gz build/subprojects/Download/nlohmann_json_dependency/v${jsonver}.tar.gz

mkdir -p build/subprojects/Download/spdlog_dependency/
cp -f ../spdlog-v${spdlogver}.tar.gz build/subprojects/Download/spdlog_dependency/v${spdlogver}.tar.gz

mkdir -p build
cd build || exit 1
cmake -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/Bear-${ver} .. || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/Bear-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/Bear-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f Bear
    ln -s Bear-${ver} Bear
fi
