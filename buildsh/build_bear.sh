#!/bin/bash

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src

if [[ ! -f /home/lixq/src/Bear-3.0.18.tar.gz ]]; then
    if ! wget https://github.com/rizsotto/Bear/archive/refs/tags/3.0.18.tar.gz -O /home/lixq/src/Bear-3.0.18.tar.gz; then
        rm -f /home/lixq/src/Bear-3.0.18.tar.gz*
        echo "Need /home/lixq/src/Bear-3.0.18.tar.gz (https://github.com/rizsotto/Bear/archive/refs/tags/3.0.18.tar.gz)"
        exit 1
    fi
fi

cd /home/lixq/src || exit 1
rm -rf Bear-3.0.18
tar -xvf Bear-3.0.18.tar.gz

# googletest
if [[ ! -f /home/lixq/src/googletest-1.11.0.tar.gz ]]; then
    if ! wget https://github.com/google/googletest/archive/release-1.11.0.tar.gz -O /home/lixq/src/googletest-1.11.0.tar.gz; then
        rm -f /home/lixq/src/googletest-1.11.0.tar.gz*
        echo "Need /home/lixq/src/googletest-1.11.0.tar.gz (https://github.com/google/googletest/archive/release-1.11.0.tar.gz)"
        exit 1
    fi
fi
[[ -d /home/lixq/src/Bear-3.0.18/build/subprojects/Download/googletest_dependency ]] || mkdir -p /home/lixq/src/Bear-3.0.18/build/subprojects/Download/googletest_dependency
cp -f /home/lixq/src/googletest-1.11.0.tar.gz /home/lixq/src/Bear-3.0.18/build/subprojects/Download/googletest_dependency/release-1.11.0.tar.gz
# json
if [[ ! -f /home/lixq/src/json-v3.10.4.tar.gz ]]; then
    if ! wget https://github.com/nlohmann/json/archive/v3.10.4.tar.gz -O /home/lixq/src/json-v3.10.4.tar.gz; then
        rm /home/lixq/src/json-v3.10.4.tar.gz*
        echo "Need /home/lixq/src/json-v3.10.4.tar.gz (https://github.com/nlohmann/json/archive/v3.10.4.tar.gz)"
        exit 1
    fi
fi
[[ -d /home/lixq/src/Bear-3.0.18/build/subprojects/Download/nlohmann_json_dependency/ ]] || mkdir -p /home/lixq/src/Bear-3.0.18/build/subprojects/Download/nlohmann_json_dependency/
cp -f /home/lixq/src/json-v3.10.4.tar.gz /home/lixq/src/Bear-3.0.18/build/subprojects/Download/nlohmann_json_dependency/v3.10.4.tar.gz
# fmt
if [[ ! -f /home/lixq/src/fmt-8.0.1.tar.gz ]]; then
    if ! wget https://github.com/fmtlib/fmt/archive/8.0.1.tar.gz -O /home/lixq/src/fmt-8.0.1.tar.gz; then
        rm /home/lixq/src/fmt-8.0.1.tar.gz*
        echo "Need /home/lixq/src/fmt-8.0.1.tar.gz (https://github.com/fmtlib/fmt/archive/8.0.1.tar.gz)"
        exit 1
    fi
fi
[[ -d /home/lixq/src/Bear-3.0.18/build/subprojects/Download/fmt_dependency/ ]] || mkdir -p /home/lixq/src/Bear-3.0.18/build/subprojects/Download/fmt_dependency/
cp -f /home/lixq/src/fmt-8.0.1.tar.gz /home/lixq/src/Bear-3.0.18/build/subprojects/Download/fmt_dependency/8.0.1.tar.gz
# spdlog
if [[ ! -f /home/lixq/src/spdlog-v1.9.2.tar.gz ]]; then
    if ! wget https://github.com/gabime/spdlog/archive/v1.9.2.tar.gz -O /home/lixq/src/spdlog-v1.9.2.tar.gz; then
        rm -f /home/lixq/src/spdlog-v1.9.2.tar.gz*
        echo "Need /home/lixq/src/spdlog-v1.9.2.tar.gz (https://github.com/gabime/spdlog/archive/v1.9.2.tar.gz)"
        exit 1
    fi
fi
[[ -d /home/lixq/src/Bear-3.0.18/build/subprojects/Download/spdlog_dependency/ ]] || mkdir -p /home/lixq/src/Bear-3.0.18/build/subprojects/Download/spdlog_dependency/
cp -f /home/lixq/src/spdlog-v1.9.2.tar.gz /home/lixq/src/Bear-3.0.18/build/subprojects/Download/spdlog_dependency/v1.9.2.tar.gz
# grpc
if [[ ! -f /home/lixq/src/grpc-v1.41.1.tar.gz ]]; then
    cd /home/lixq/src || exit 1
    if [[ ! -d /home/lixq/src/grpc-v1.41.1 ]]; then
        if ! git clone --depth 1 https://github.com/grpc/grpc -b v1.41.1 grpc-v1.41.1; then
            echo "Need /home/lixq/src/grpc-v1.41.1 (https://github.com/grpc/grpc)"
            exit 1
        fi
        for d in /home/lixq/src/grpc-v1.41.1 \
            /home/lixq/src/grpc-v1.41.1/third_party/bloaty \
            /home/lixq/src/grpc-v1.41.1/third_party/protobuf; do
            cd "$d" || exit 1
            pwd
            sed -i 's;github.com/;github.com.cnpmjs.org/;' .gitmodules
            git submodule update --init
        done
    fi
    tar -czvf grpc-v1.41.1.tar.gz grpc-v1.41.1
fi
n=$(awk '/ExternalProject_Add/{print FNR}' /home/lixq/src/Bear-3.0.18/third_party/grpc/CMakeLists.txt)
sed -i "$((n+1)),$((n+7))c\            URL\n                https://github.com/grpc/grpc/archive/refs/tags/v1.41.1.tar.gz\n            URL_HASH\n                MD5=$(md5sum /home/lixq/src/grpc-v1.41.1.tar.gz | awk '{print $1}')\n            DOWNLOAD_NO_PROGRESS\n                1" /home/lixq/src/Bear-3.0.18/third_party/grpc/CMakeLists.txt
[[ -d /home/lixq/src/Bear-3.0.18/build/subprojects/Download/grpc_dependency/ ]] || mkdir -p /home/lixq/src/Bear-3.0.18/build/subprojects/Download/grpc_dependency/
cp -f /home/lixq/src/grpc-v1.41.1.tar.gz /home/lixq/src/Bear-3.0.18/build/subprojects/Download/grpc_dependency/v1.41.1.tar.gz

[[ -d /home/lixq/src/Bear-3.0.18/build ]] || mkdir -p /home/lixq/src/Bear-3.0.18/build
cd /home/lixq/src/Bear-3.0.18/build || exit 1
rm -rf /home/lixq/toolchains/Bear-3.0.18
export CC=/home/lixq/toolchains/gcc/bin/gcc
export CXX=/home/lixq/toolchains/gcc/bin/g++
export CPP=/home/lixq/toolchains/gcc/bin/cpp
export LIBRARY_PATH=/home/lixq/toolchains/gcc/lib64
export LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/gcc/lib64"
cmake -DCMAKE_INSTALL_PREFIX=/home/lixq/toolchains/Bear-3.0.18 ..
make || exit 1
make install || exit 1
if [[ -d /home/lixq/toolchains/Bear-3.0.18 ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f Bear
    ln -s Bear-3.0.18 Bear
fi
