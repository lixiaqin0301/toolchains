#!/bin/bash

ver=3.0.19

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src

if [[ ! -f /home/lixq/src/Bear-${ver}.tar.gz ]]; then
    if ! wget https://github.com/rizsotto/Bear/archive/refs/tags/${ver}.tar.gz -O /home/lixq/src/Bear-${ver}.tar.gz; then
        rm -f /home/lixq/src/Bear-${ver}.tar.gz*
        echo "Need /home/lixq/src/Bear-${ver}.tar.gz (https://github.com/rizsotto/Bear/archive/refs/tags/${ver}.tar.gz)"
        exit 1
    fi
fi

cd /home/lixq/src || exit 1
rm -rf Bear-${ver}
tar -xvf Bear-${ver}.tar.gz

# fmt
fmtver=8.1.1
if [[ ! -f /home/lixq/src/fmt-${fmtver}.tar.gz ]]; then
    if ! wget https://github.com/fmtlib/fmt/archive/${fmtver}.tar.gz -O /home/lixq/src/fmt-${fmtver}.tar.gz; then
        rm /home/lixq/src/fmt-${fmtver}.tar.gz*
        echo "Need /home/lixq/src/fmt-${fmtver}.tar.gz (https://github.com/fmtlib/fmt/archive/${fmtver}.tar.gz)"
        exit 1
    fi
fi
[[ -d /home/lixq/src/Bear-${ver}/build/subprojects/Download/fmt_dependency/ ]] || mkdir -p /home/lixq/src/Bear-${ver}/build/subprojects/Download/fmt_dependency/
cp -f /home/lixq/src/fmt-${fmtver}.tar.gz /home/lixq/src/Bear-${ver}/build/subprojects/Download/fmt_dependency/${fmtver}.tar.gz

# googletest
googletestver=1.11.0
if [[ ! -f /home/lixq/src/googletest-${googletestver}.tar.gz ]]; then
    if ! wget https://github.com/google/googletest/archive/release-${googletestver}.tar.gz -O /home/lixq/src/googletest-${googletestver}.tar.gz; then
        rm -f /home/lixq/src/googletest-${googletestver}.tar.gz*
        echo "Need /home/lixq/src/googletest-${googletestver}.tar.gz (https://github.com/google/googletest/archive/release-${googletestver}.tar.gz)"
        exit 1
    fi
fi
[[ -d /home/lixq/src/Bear-${ver}/build/subprojects/Download/googletest_dependency ]] || mkdir -p /home/lixq/src/Bear-${ver}/build/subprojects/Download/googletest_dependency
cp -f /home/lixq/src/googletest-${googletestver}.tar.gz /home/lixq/src/Bear-${ver}/build/subprojects/Download/googletest_dependency/release-${googletestver}.tar.gz

# grpc
grpcver=1.41.1
if [[ ! -f /home/lixq/src/grpc-v${grpcver}.tar.gz ]]; then
    cd /home/lixq/src || exit 1
    if [[ ! -d /home/lixq/src/grpc-v${grpcver} ]]; then
        if ! git clone --depth 1 https://github.com/grpc/grpc -b v${grpcver} grpc-v${grpcver}; then
            echo "Need /home/lixq/src/grpc-v${grpcver} (https://github.com/grpc/grpc)"
            exit 1
        fi
        for d in /home/lixq/src/grpc-v${grpcver} \
            /home/lixq/src/grpc-v${grpcver}/third_party/bloaty \
            /home/lixq/src/grpc-v${grpcver}/third_party/protobuf; do
            cd "$d" || exit 1
            pwd
            git submodule update --init
        done
    fi
    tar -czvf grpc-v${grpcver}.tar.gz grpc-v${grpcver}
fi
n=$(awk '/ExternalProject_Add/{print FNR}' /home/lixq/src/Bear-${ver}/third_party/grpc/CMakeLists.txt)
sed -i "$((n+1)),$((n+7))c\            URL\n                https://github.com/grpc/grpc/archive/refs/tags/v${grpcver}.tar.gz\n            URL_HASH\n                MD5=$(md5sum /home/lixq/src/grpc-v${grpcver}.tar.gz | awk '{print $1}')\n            DOWNLOAD_NO_PROGRESS\n                1" /home/lixq/src/Bear-${ver}/third_party/grpc/CMakeLists.txt
[[ -d /home/lixq/src/Bear-${ver}/build/subprojects/Download/grpc_dependency/ ]] || mkdir -p /home/lixq/src/Bear-${ver}/build/subprojects/Download/grpc_dependency/
cp -f /home/lixq/src/grpc-v${grpcver}.tar.gz /home/lixq/src/Bear-${ver}/build/subprojects/Download/grpc_dependency/v${grpcver}.tar.gz

# json
jsonver=3.10.5
if [[ ! -f /home/lixq/src/json-v${jsonver}.tar.gz ]]; then
    if ! wget https://github.com/nlohmann/json/archive/v${jsonver}.tar.gz -O /home/lixq/src/json-v${jsonver}.tar.gz; then
        rm /home/lixq/src/json-v${jsonver}.tar.gz*
        echo "Need /home/lixq/src/json-v${jsonver}.tar.gz (https://github.com/nlohmann/json/archive/v${jsonver}.tar.gz)"
        exit 1
    fi
fi
[[ -d /home/lixq/src/Bear-${ver}/build/subprojects/Download/nlohmann_json_dependency/ ]] || mkdir -p /home/lixq/src/Bear-${ver}/build/subprojects/Download/nlohmann_json_dependency/
cp -f /home/lixq/src/json-v${jsonver}.tar.gz /home/lixq/src/Bear-${ver}/build/subprojects/Download/nlohmann_json_dependency/v${jsonver}.tar.gz

# spdlog
spdlogver=1.9.2
if [[ ! -f /home/lixq/src/spdlog-v${spdlogver}.tar.gz ]]; then
    if ! wget https://github.com/gabime/spdlog/archive/v${spdlogver}.tar.gz -O /home/lixq/src/spdlog-v${spdlogver}.tar.gz; then
        rm -f /home/lixq/src/spdlog-v${spdlogver}.tar.gz*
        echo "Need /home/lixq/src/spdlog-v${spdlogver}.tar.gz (https://github.com/gabime/spdlog/archive/v${spdlogver}.tar.gz)"
        exit 1
    fi
fi
[[ -d /home/lixq/src/Bear-${ver}/build/subprojects/Download/spdlog_dependency/ ]] || mkdir -p /home/lixq/src/Bear-${ver}/build/subprojects/Download/spdlog_dependency/
cp -f /home/lixq/src/spdlog-v${spdlogver}.tar.gz /home/lixq/src/Bear-${ver}/build/subprojects/Download/spdlog_dependency/v${spdlogver}.tar.gz

[[ -d /home/lixq/src/Bear-${ver}/build ]] || mkdir -p /home/lixq/src/Bear-${ver}/build
cd /home/lixq/src/Bear-${ver}/build || exit 1
rm -rf /home/lixq/toolchains/Bear-${ver}
export CC=/home/lixq/toolchains/gcc/bin/gcc
export CXX=/home/lixq/toolchains/gcc/bin/g++
export CPP=/home/lixq/toolchains/gcc/bin/cpp
export LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64
export LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/gcc/lib64"
cmake -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/Bear-${ver} ..
make || exit 1
make install || exit 1
if [[ -d /home/lixq/toolchains/Bear-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f Bear
    ln -s Bear-${ver} Bear
fi
