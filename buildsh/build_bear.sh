#!/bin/bash

[[ -d /home/lixq/toolchains/src ]] || mkdir -p /home/lixq/toolchains/src

if [[ ! -f /home/lixq/toolchains/src/Bear-3.0.16.tar.gz ]]; then
    if ! wget https://github.com/rizsotto/Bear/archive/refs/tags/3.0.16.tar.gz -O /home/lixq/toolchains/src/Bear-3.0.16.tar.gz; then
        rm -f /home/lixq/toolchains/src/Bear-3.0.16.tar.gz*
        echo "Need /home/lixq/toolchains/src/Bear-3.0.16.tar.gz (https://github.com/rizsotto/Bear/archive/refs/tags/3.0.16.tar.gz)"
        exit 1
    fi
fi


cd /home/lixq/toolchains/src || exit 1
rm -rf Bear-3.0.16
tar -xvf Bear-3.0.16.tar.gz
# googletest
if [[ ! -f /home/lixq/toolchains/src/googletest-1.11.0.tar.gz ]]; then
    if ! wget https://github.com/google/googletest/archive/release-1.11.0.tar.gz -O /home/lixq/toolchains/src/googletest-1.11.0.tar.gz; then
        rm -f /home/lixq/toolchains/src/googletest-1.11.0.tar.gz*
        echo "Need /home/lixq/toolchains/src/googletest-1.11.0.tar.gz (https://github.com/google/googletest/archive/release-1.11.0.tar.gz)"
        exit 1
    fi
fi
[[ -d /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/googletest_dependency ]] || mkdir -p /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/googletest_dependency
cp -f /home/lixq/toolchains/src/googletest-1.11.0.tar.gz /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/googletest_dependency/release-1.11.0.tar.gz
# json
if [[ ! -f /home/lixq/toolchains/src/json-v3.10.2.tar.gz ]]; then
    if ! wget https://github.com/nlohmann/json/archive/v3.10.2.tar.gz -O /home/lixq/toolchains/src/json-v3.10.2.tar.gz; then
        rm /home/lixq/toolchains/src/json-v3.10.2.tar.gz*
        echo "Need /home/lixq/toolchains/src/json-v3.10.2.tar.gz (https://github.com/nlohmann/json/archive/v3.10.2.tar.gz)"
        exit 1
    fi
fi
[[ -d /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/nlohmann_json_dependency/ ]] || mkdir -p /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/nlohmann_json_dependency/
cp -f /home/lixq/toolchains/src/json-v3.10.2.tar.gz /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/nlohmann_json_dependency/v3.10.2.tar.gz
# fmt
if [[ ! -f /home/lixq/toolchains/src/fmt-8.0.1.tar.gz ]]; then
    if ! wget https://github.com/fmtlib/fmt/archive/8.0.1.tar.gz -O /home/lixq/toolchains/src/fmt-8.0.1.tar.gz; then
        rm /home/lixq/toolchains/src/fmt-8.0.1.tar.gz*
        echo "Need /home/lixq/toolchains/src/fmt-8.0.1.tar.gz (https://github.com/fmtlib/fmt/archive/8.0.1.tar.gz)"
        exit 1
    fi
fi
[[ -d /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/fmt_dependency/ ]] || mkdir -p /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/fmt_dependency/
cp -f /home/lixq/toolchains/src/fmt-8.0.1.tar.gz /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/fmt_dependency/8.0.1.tar.gz
# spdlog
if [[ ! -f /home/lixq/toolchains/src/spdlog-v1.9.2.tar.gz ]]; then
    if ! wget https://github.com/gabime/spdlog/archive/v1.9.2.tar.gz -O /home/lixq/toolchains/src/spdlog-v1.9.2.tar.gz; then
        rm -f /home/lixq/toolchains/src/spdlog-v1.9.2.tar.gz*
        echo "Need /home/lixq/toolchains/src/spdlog-v1.9.2.tar.gz (https://github.com/gabime/spdlog/archive/v1.9.2.tar.gz)"
        exit 1
    fi
fi
[[ -d /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/spdlog_dependency/ ]] || mkdir -p /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/spdlog_dependency/
cp -f /home/lixq/toolchains/src/spdlog-v1.9.2.tar.gz /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/spdlog_dependency/v1.9.2.tar.gz
# grpc
if [[ ! -f /home/lixq/toolchains/src/grpc-v1.36.4.tar.gz ]]; then
    cd /home/lixq/toolchains/src || exit 1
    if [[ ! -d /home/lixq/toolchains/src/grpc-v1.36.4 ]]; then
        if ! git clone --depth 1 https://github.com.cnpmjs.org/grpc/grpc -b v1.36.4 grpc-v1.36.4; then
            echo "Need /home/lixq/toolchains/src/grpc-v1.36.4 (https://github.com/grpc/grpc)"
            exit 1
        fi
        for d in /home/lixq/toolchains/src/grpc-v1.36.4 \
            /home/lixq/toolchains/src/grpc-v1.36.4/third_party/bloaty \
            /home/lixq/toolchains/src/grpc-v1.36.4/third_party/protobuf; do
            cd "$d" || exit 1
            pwd
            sed -i 's;github.com/;github.com.cnpmjs.org/;' .gitmodules
            git submodule update --init
        done
    fi
    tar -czvf grpc-v1.36.4.tar.gz grpc-v1.36.4
fi
n=$(awk '/ExternalProject_Add/{print FNR}' /home/lixq/toolchains/src/Bear-3.0.16/third_party/grpc/CMakeLists.txt)
sed -i "$((n+1)),$((n+7))c\            URL\n                https://github.com.cnpmjs.org/grpc/grpc/archive/refs/tags/v1.36.4.tar.gz\n            URL_HASH\n                MD5=$(md5sum /home/lixq/toolchains/src/grpc-v1.36.4.tar.gz | awk '{print $1}')\n            DOWNLOAD_NO_PROGRESS\n                1" /home/lixq/toolchains/src/Bear-3.0.16/third_party/grpc/CMakeLists.txt
[[ -d /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/grpc_dependency/ ]] || mkdir -p /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/grpc_dependency/
cp -f /home/lixq/toolchains/src/grpc-v1.36.4.tar.gz /home/lixq/toolchains/src/Bear-3.0.16/build/subprojects/Download/grpc_dependency/v1.36.4.tar.gz

[[ -d /home/lixq/toolchains/src/Bear-3.0.16/build ]] || mkdir -p /home/lixq/toolchains/src/Bear-3.0.16/build
cd /home/lixq/toolchains/src/Bear-3.0.16/build || exit 1
rm -rf /home/lixq/toolchains/Bear-3.0.16
export CC=/home/lixq/toolchains/gcc/bin/gcc
export CXX=/home/lixq/toolchains/gcc/bin/g++
export CPP=/home/lixq/toolchains/gcc/bin/cpp
export LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64
export LD_LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64
export LD_RUN_PATH=/home/lixq/toolchains/gcc/lib64
cmake -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/Bear-3.0.16 ..
make || exit 1
make install || exit 1
if [[ -d /home/lixq/toolchains/Bear-3.0.16 ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f Bear
    ln -s Bear-3.0.16 Bear
fi
