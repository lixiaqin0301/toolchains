#!/bin/bash

ver=v16.20.2

export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/home/lixq/toolchains/Bear/bin"
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/35share-rd/src/node-${ver}.tar.gz ]]; then
    echo "wget https://nodejs.org/dist/${ver}/node-${ver}.tar.gz"
    exit 1
fi
[[ -d /home/lixq/workspace-vscode ]] || mkdir /home/lixq/workspace-vscode
cd /home/lixq/workspace-vscode || exit 1
rm -rf node-${ver}
tar -xf /home/lixq/35share-rd/src/node-${ver}.tar.gz
cd node-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/node-${ver} --shared || exit 1
bear -- make || exit 1
rm -rf /home/lixq/toolchains/node-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/node-${ver}/lib ]]; then
    cd /home/lixq/toolchains/node-${ver}/lib || exit 1
    ln -s libnode.so.* libnode.so
fi
