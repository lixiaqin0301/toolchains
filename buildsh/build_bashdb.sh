#!/bin/bash

ver=4.4-1.0.1
[[ -d /home/lixq/src ]] || mkdir -p /home/lixq/src

# bashdb https://sourceforge.net/projects/bashdb/files/bashdb/
if [[ ! -f /home/lixq/src/bashdb-${ver}.tar.bz2 ]]; then
    if ! wget https://jaist.dl.sourceforge.net/project/bashdb/bashdb/${ver}/bashdb-${ver}.tar.bz2; then
        rm -f /home/lixq/src/bashdb-${ver}.tar.bz2*
        echo "Need /home/lixq/src/bashdb-${ver}.tar.bz2 (https://jaist.dl.sourceforge.net/project/bashdb/bashdb/${ver}/bashdb-${ver}.tar.bz2)"
        exit 1
    fi
fi
cd /home/lixq/src || exit 1
rm -rf bashdb-${ver}
tar -xvf bashdb-${ver}.tar.bz2
cd /home/lixq/src/bashdb-${ver} || exit 1
rm -rf /home/lixq/toolchains/bashdb-${ver}
./configure --prefix=/home/lixq/toolchains/bashdb-${ver}
make
make install
if [[ -d /home/lixq/toolchains/bashdb-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm bashdb
    ln -s bashdb-${ver} bashdb
fi
