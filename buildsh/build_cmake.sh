#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=4.3.4
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver-linux-x86_64.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

mkdir -p "$DESTDIR/usr"
cd "$DESTDIR/usr" || exit 1
tar -xf "$srcpath" --strip-components=1 || exit 1
