#!/bin/bash

ver=5.9

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/35share-rd/src/zsh-${ver}.tar.xz ]]; then
    echo "wget https://nchc.dl.sourceforge.net/project/zsh/zsh/${ver}/zsh-${ver}.tar.xz"
    exit 1
fi
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf zsh-${ver}
tar -xvf /home/lixq/35share-rd/src/zsh-${ver}.tar.xz
mkdir zsh-${ver}/build
cd zsh-${ver}/build || exit 1
../configure --prefix=/home/lixq/toolchains/zsh-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/zsh-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/zsh-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f zsh
    ln -s zsh-${ver} zsh
fi
