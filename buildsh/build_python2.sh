#!/bin/bash

ver=2.7.18

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

if [[ ! -f /home/lixq/src/Python-${ver}.tar.xz ]]; then
    echo "wget https://www.python.org/ftp/python/${ver}/Python-${ver}.tar.xz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf Python-${ver}
tar -xf /home/lixq/src/Python-${ver}.tar.xz
cd Python-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/Python-${ver} --with-ensurepip=install || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/Python-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/Python-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f Python
    ln -s Python-${ver} Python
fi
