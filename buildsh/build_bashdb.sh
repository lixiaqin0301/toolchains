#!/bin/bash

ver=4.4-1.0.1

# bashdb https://sourceforge.net/projects/bashdb/files/bashdb/
if [[ ! -f /home/lixq/src/bashdb-${ver}.tar.bz2 ]]; then
    echo "wget https://jaist.dl.sourceforge.net/project/bashdb/bashdb/${ver}/bashdb-${ver}.tar.bz2 -O /home/lixq/src/bashdb-${ver}.tar.bz2"
    exit 1
fi

cd /home/lixq/src || exit 1
rm -rf bashdb-${ver}
tar -xvf bashdb-${ver}.tar.bz2
cd /home/lixq/src/bashdb-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/bashdb-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/bashdb-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/bashdb-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm bashdb
    ln -s bashdb-${ver} bashdb
fi
