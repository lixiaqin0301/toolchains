#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=$1
DESTDIR=$2
srcpath=/share-rd/cdn_prd_cache/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export MANPATH=
export PCP_DIR=
export LD_LIBRARY_PATH=
export PKG_CONFIG_PATH=
export INFOPATH=
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

if [[ $DESTDIR == /home/lixq/toolchains/gcc ]]; then
    export PATH="/opt/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
    export LDFLAGS="-L/opt/gcc/usr/lib64 -Wl,-rpath-link,/opt/gcc/usr/lib64 -Wl,-rpath,/home/lixq/toolchains/gcc/usr/lib64"
else
    export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
    export LDFLAGS="-L/home/lixq/toolchains/gcc/usr/lib64 -Wl,-rpath-link,/home/lixq/toolchains/gcc/usr/lib64 -Wl,-rpath,/opt/gcc/usr/lib64"
fi

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
cp -a /share-rd/cdn_prd_cache/lixq/src/"$(grep "^gmp='gmp" ./contrib/download_prerequisites | awk -F "'" '{print $2}')" .
cp -a /share-rd/cdn_prd_cache/lixq/src/"$(grep "^mpfr='mpfr" ./contrib/download_prerequisites | awk -F "'" '{print $2}')" .
cp -a /share-rd/cdn_prd_cache/lixq/src/"$(grep "^mpc='mpc" ./contrib/download_prerequisites | awk -F "'" '{print $2}')" .
cp -a /share-rd/cdn_prd_cache/lixq/src/"$(grep "^isl='isl" ./contrib/download_prerequisites | awk -F "'" '{print $2}')" .
cp -a /share-rd/cdn_prd_cache/lixq/src/"$(grep "^gettext='gettext" ./contrib/download_prerequisites | awk -F "'" '{print $2}')" .
./contrib/download_prerequisites
mkdir -p "/home/lixq/src/$name-$ver/build"
cd "/home/lixq/src/$name-$ver/build"
../configure --prefix="$DESTDIR/usr" --disable-multilib --enable-ld
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
cd "$DESTDIR/usr/bin"
ln -s gcc cc
