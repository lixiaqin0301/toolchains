#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=1_92_0
DESTDIR=$1
srcpath=/home/lixq/src/${name}_$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export MANPATH=
export PCP_DIR=
export LD_LIBRARY_PATH=
export PKG_CONFIG_PATH=
export INFOPATH=
export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export LD_RUN_PATH="/home/lixq/toolchains/gcc/usr/lib64"

cd /home/lixq/src
rm -rf "${name}_$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/${name}_$ver"
./bootstrap.sh "--prefix=$DESTDIR/usr"
./b2 "-j$(nproc)"
./b2 "-j$(nproc)" install
