#!/bin/bash

ver=2.45.2

if [[ ! -f /home/lixq/35share-rd/src/git-${ver}.tar.gz ]]; then
    echo "wget https://github.com/git/git/archive/refs/tags/v${ver}.tar.gz -O git-${ver}.tar.gz"
    exit 1
fi
if ! wget http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl -O /tmp/docbook.xsl; then
    echo "get git doc"
    echo 1
fi

export PATH=/home/lixq/toolchains/Anaconda3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable
export CPATH="/home/lixq/toolchains/Anaconda3/include:$CPATH"
export PKG_CONFIG_PATH="/home/lixq/toolchains/Anaconda3/lib/pkgconfig:$PKG_CONFIG_PATH"
export LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/Anaconda3/lib $LDFLAGS"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf git-${ver}
tar -xvf /home/lixq/35share-rd/src/git-${ver}.tar.gz
cd git-${ver} || exit 1
sed -i 's;^\(GITLIBS = .*\);\1 /home/lixq/toolchains/Anaconda3/lib/libiconv.a;' Makefile
make configure || exit 1
./configure --prefix=/home/lixq/toolchains/git-${ver} || exit 1
make all doc || exit 1
rm -rf /home/lixq/toolchains/git-${ver}
make install install-doc install-html || exit 1
if [[ -d /home/lixq/toolchains/git-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm git
    ln -s git-${ver} git
fi
