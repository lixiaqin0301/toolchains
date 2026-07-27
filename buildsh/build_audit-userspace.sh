#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=4.2
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
sed -i '/#include <linux\/netlink.h>/a #ifndef SOL_NETLINK\
#define SOL_NETLINK 270\
#endif' src/auditd.c
autoreconf -fi
./configure "--prefix=$DESTDIR/usr" --disable-zos-remote --with-python3=no
cp -ar "src/test/\${top_srcdir}/src/.deps" src
cp -ar "audisp/test/\${top_srcdir}/audisp/.deps" audisp
cp -ar "tools/aulast/test/\${top_srcdir}/tools/aulast/.deps" tools/aulast
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
