#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=6.6
DESTDIR=$1
srcpath=/home/lixq/src/$name.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

ncurses_options=(--with-shared --without-ada --with-ospeed=unsigned --enable-hard-tabs --enable-xmc-glitch --enable-colorfgbg --enable-overwrite --enable-pc-files --with-termlib=tinfo --with-chtype=long --with-cxx-shared --with-xterm-kbs=DEL "--prefix=$DESTDIR/usr")

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
mkdir narrowc widec

cd "/home/lixq/src/$name-$ver/narrowc"
ln -s ../configure .
./configure "${ncurses_options[@]}" --disable-widec --with-ticlib
make -s "-j$(nproc)" libs
make -s "-j$(nproc)" -C progs

cd "/home/lixq/src/$name-$ver/widec"
ln -s ../configure .
./configure "${ncurses_options[@]}" --without-progs
make -s "-j$(nproc)" libs

cd "/home/lixq/src/$name-$ver"
make -C narrowc install.{libs,progs,data}
make -C widec install.{libs,includes,man}
