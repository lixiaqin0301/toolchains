#!/bin/bash

ver=2.43.0

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/src/git-${ver}.tar.gz ]]; then
    echo "wget https://github.com/git/git/archive/refs/tags/v${ver}.tar.gz -O /home/lixq/src/git-${ver}.tar.gz"
    exit 1
fi

cd /home/lixq/src || exit 1
rm -rf git-${ver}
tar -xvf git-${ver}.tar.gz
cd git-${ver} || exit 1
make prefix=/home/lixq/toolchains/git-${ver} || exit 1
rm -rf /home/lixq/toolchains/git-${ver}
make prefix=/home/lixq/toolchains/git-${ver} install || exit 1
if [[ -d /home/lixq/toolchains/git-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm git
    ln -s git-${ver} git
fi
