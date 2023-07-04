#!/bin/bash

ver=1_82_0

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/src/boost_${ver}.tar.gz ]]; then
    echo "wget get wget https://boostorg.jfrog.io/artifactory/main/release/${ver//_/.}/source/boost_${ver}.tar.g -O /home/lixq/src/boost_${ver}.tar.gz"
    exit 1
fi

cd /home/lixq/src || exit 1
rm -rf boost_${ver}
tar -xvf boost_${ver}.tar.gz
cd boost_${ver} || exit 1
./bootstrap.sh --prefix=/home/lixq/toolchains/boost_${ver} || exit 1
./b2 || exit 1
rm -rfv /home/lixq/toolchains/boost_${ver}
./b2 install || exit 1

if [[ -d /home/lixq/toolchains/boost_${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f boost
    ln -s boost_${ver} boost
fi
