#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

[[ -d /home/lixq/toolchains/src ]] || mkdir -p /home/lixq/toolchains/src

if [[ ! -f /home/lixq/toolchains/src/git-2.33.1.tar.gz ]]; then
    if ! wget https://github.com.cnpmjs.org/git/git/archive/refs/tags/v2.33.1.tar.gz -O /home/lixq/toolchains/src/git-2.33.1.tar.gz; then
        rm -f /home/lixq/toolchains/src/git-2.33.1.tar.gz*
        echo "Need /home/lixq/toolchains/src/git-2.33.1.tar.gz (https://github.com/git/git/archive/refs/tags/v2.33.1.tar.gz)"
        exit 1
    fi
fi

cd /home/lixq/toolchains/src || exit 1
rm -rf git-2.33.1 /home/lixq/toolchains/git-2.33.1
tar -xvf git-2.33.1.tar.gz
cd /home/lixq/toolchains/src/git-2.33.1 || exit 1
make prefix=/home/lixq/toolchains/git-2.33.1 || exit 1
make prefix=/home/lixq/toolchains/git-2.33.1 install || exit 1
if [[ -d /home/lixq/toolchains/git-2.33.1 ]]; then
    cd /home/lixq/toolchains || exit 1
    rm git
    ln -s git-2.33.1 git
fi
