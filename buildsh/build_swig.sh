#!/bin/bash

ver=4.3.0

export PATH=/home/lixq/toolchains/bison/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/35share-rd/src/swig-${ver}.tar.gz ]]; then
    echo "wget https://github.com/swig/swig/archive/refs/tags/v${ver}.tar.gz -O swig-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf swig-${ver}
tar -xvf /home/lixq/35share-rd/src/swig-${ver}.tar.gz
cd swig-${ver} || exit 1
./autogen.sh || exit 1
./configure --prefix=/home/lixq/toolchains/swig-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/swig-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/swig-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f swig
    ln -s swig-${ver} swig
fi
