#!/bin/bash

export PATH=/home/lixq/toolchains/cmake/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

ver=3.1.1
grpcver=1.49.2

if [[ ! -f /home/lixq/src/Bear-${ver}.tar.gz ]]; then
    echo "wget https://github.com/rizsotto/Bear/archive/refs/tags/${ver}.tar.gz -O /home/lixq/src/Bear-${ver}.tar.gz"
    exit 1
fi

for p in                                               \
    google/googletest/archive/refs/tags/v1.13.0.tar.gz \
    nlohmann/json/archive/v3.11.2.tar.gz               \
    fmtlib/fmt/archive/9.1.0.tar.gz                    \
    gabime/spdlog/archive/v1.11.0.tar.gz               \
    ; do
    if [[ ! -f /home/lixq/src/nginx_bear/${p} ]]; then
        echo "wget https://github.com/${p} -O /home/lixq/src/nginx_bear/${p}"
        exit 1
    fi
done

if [[ ! -f /home/lixq/src/nginx_bear/grpc/grpc/archive/refs/tags/v${grpcver}.tar.gz ]]; then
    echo "cd /home/lixq/src/nginx_bear/grpc/grpc/archive/refs/tags/"
    echo "git clone --depth 1 https://github.com/grpc/grpc -b v${grpcver} v${grpcver}"
    echo "cd v${grpcver} && git submodule update --init; cd .."
    echo "tar -czvf v${grpcver}.tar.gz v${grpcver}"
    exit 1
fi

cd /home/lixq/src || exit 1

rm -rf Bear-${ver}
tar -xvf Bear-${ver}.tar.gz
n=$(awk '/ExternalProject_Add/{print FNR}' /home/lixq/src/Bear-${ver}/third_party/grpc/CMakeLists.txt)
sed -i "$((n+1)),$((n+7))c\            URL\n                https://github.com/grpc/grpc/archive/refs/tags/v${grpcver}.tar.gz\n            URL_HASH\n                MD5=$(md5sum /home/lixq/src/nginx_bear/grpc/grpc/archive/refs/tags/v${grpcver}.tar.gz | awk '{print $1}')\n            DOWNLOAD_NO_PROGRESS\n                1" /home/lixq/src/Bear-${ver}/third_party/grpc/CMakeLists.txt

cd /home/lixq/src/Bear-${ver} || exit 1

while killall nginx; do
    sleep 1
done

if ss -ltpn | grep ':443 '; then
    exit 1
fi

nginx -c /home/lixq/src/nginx_bear/nginx.conf || exit 1
until ss -ltpn | grep ':443 '; do
    sleep 1
done
:> /tmp/nginx_access.log
sed -i -e '/github.com/d' /etc/hosts
sed -i -e '$a 127.0.0.1 github.com' /etc/hosts

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
