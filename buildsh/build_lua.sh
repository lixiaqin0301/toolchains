#!/bin/bash

ver=5.4.7

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/35share-rd/src/lua-${ver}.tar.gz ]]; then
    echo "wget https://www.lua.org/ftp/lua-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf lua-${ver}
tar -xf /home/lixq/35share-rd/src/lua-${ver}.tar.gz
cd lua-${ver} || exit 1
sed -i "/^INSTALL_TOP/c INSTALL_TOP= /home/lixq/toolchains/lua-${ver}" Makefile
sed -i "s;^\(CFLAGS= .*\);\1 -fPIC;" src/Makefile
make all test || exit 1
rm -rf /home/lixq/toolchains/lua-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/lua-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f lua
    ln -s lua-${ver} lua
fi
