#!/bin/bash

ver=1.25.3.2

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

if [[ ! -f /home/lixq/35share-rd/src/openresty-${ver}.tar.gz ]]; then
    echo "wget https://openresty.org/download/openresty-${ver}.tar.gz -O openresty-${ver}.tar.gz"
    exit 1
fi

[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf openresty-${ver}
tar -xvf /home/lixq/35share-rd/src/openresty-${ver}.tar.gz
cd openresty-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/openresty-${ver} || exit 1
gmake || exit 1
rm -rf /home/lixq/toolchains/openresty-${ver}
gmake install || exit 1
if [[ -d /home/lixq/toolchains/openresty-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f openresty
    ln -s openresty-${ver} openresty
fi
