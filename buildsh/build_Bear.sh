#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=4.2.2
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export MANPATH=
export PCP_DIR=
export LD_LIBRARY_PATH=
export PKG_CONFIG_PATH=
export INFOPATH=
export PATH="/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
. /opt/rh/devtoolset-11/enable

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
# 阿里云好久没有更新rustup镜像了 等阿里云更新后两个update都不需要
cargo update
cargo update -p find-msvc-tools --precise 0.1.11
cargo build --release
mkdir -p "$DESTDIR/usr"
PREFIX="$DESTDIR/usr" ./scripts/install.sh
