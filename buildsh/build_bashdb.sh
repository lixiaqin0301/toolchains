#!/bin/bash

[[ -d /home/lixq/toolchains/src ]] || mkdir -p /home/lixq/toolchains/src

# bashdb https://sourceforge.net/projects/bashdb/files/bashdb/
if [[ ! -f /home/lixq/toolchains/src/bashdb-4.4-1.0.1.tar.bz2 ]]; then
    if ! wget https://jaist.dl.sourceforge.net/project/bashdb/bashdb/4.4-1.0.1/bashdb-4.4-1.0.1.tar.bz2; then
        rm -f /home/lixq/toolchains/src/bashdb-4.4-1.0.1.tar.bz2*
        echo "Need /home/lixq/toolchains/src/bashdb-4.4-1.0.1.tar.bz2 (https://jaist.dl.sourceforge.net/project/bashdb/bashdb/4.4-1.0.1/bashdb-4.4-1.0.1.tar.bz2)"
        exit 1
    fi
fi
cd /home/lixq/toolchains/src || exit 1
rm -rf bashdb-4.4-1.0.1
tar -xvf bashdb-4.4-1.0.1.tar.bz2
cd /home/lixq/toolchains/src/bashdb-4.4-1.0.1 || exit 1
rm -rf /home/lixq/toolchains/bashdb-4.4-1.0.1
./configure --prefix=/home/lixq/toolchains/bashdb-4.4-1.0.1
make
make install
if [[ -d /home/lixq/toolchains/bashdb-4.4-1.0.1 ]]; then
    cd /home/lixq/toolchains || exit 1
    rm bashdb
    ln -s bashdb-4.4-1.0.1 bashdb
fi
