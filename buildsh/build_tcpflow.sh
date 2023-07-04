#!/bin/bash

ver=1.6.1

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

export CFLAGS="-I/home/lixq/toolchains/boost/include"
export CPPFLAGS="-I/home/lixq/toolchains/boost/include"
export LDFLAGS="-Wno-strict-prototypes -L/home/lixq/toolchains/boost/lib -Wl,-rpath,/home/lixq/toolchains/boost/lib"

if [[ ! -f /home/lixq/src/tcpflow-${ver}.tar.gz ]]; then
    echo "wget get https://github.com/simsong/tcpflow/releases/download/tcpflow-${ver}/tcpflow-${ver}.tar.gz -O /home/lixq/src/tcpflow-${ver}.tar.gz"
    exit 1
fi

cd /home/lixq/src || exit 1
rm -rf tcpflow-${ver}
tar -xvf tcpflow-${ver}.tar.gz
cd tcpflow-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/tcpflow-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/tcpflow-${ver}
make install || exit 1

if [[ -d /home/lixq/toolchains/tcpflow-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm tcpflow
    ln -s tcpflow-${ver} tcpflow
fi
