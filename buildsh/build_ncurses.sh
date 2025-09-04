#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=6.3
DESTDIR=$1
srcpath=/home/lixq/src/$name.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
ncurses_options=(--with-shared --without-ada --with-ospeed=unsigned --enable-hard-tabs --enable-xmc-glitch --enable-colorfgbg --enable-overwrite --enable-pc-files --with-termlib=tinfo --with-chtype=long --with-cxx-shared --with-xterm-kbs=DEL)
mkdir narrowc widec
cd narrowc || exit 1
ln -s ../configure .
./configure "${ncurses_options[@]}" --with-ticlib || exit 1
make -s "-j$(nproc)" libs || exit 1
make -s "-j$(nproc)" -C progs || exit 1
cd ../widec || exit 1
ln -s ../configure .
./configure "${ncurses_options[@]}" --enable-widec --without-progs || exit 1
make -s "-j$(nproc)" libs || exit 1
cd ..
make -C narrowc "DESTDIR=$DESTDIR" install.{libs,progs,data}
make -C widec "DESTDIR=$DESTDIR" install.{libs,includes,man}
mkdir "$DESTDIR/usr/include"/ncurses{,w}
for l in "$DESTDIR/usr/include"/*.h; do
    ln -s "../$(basename "$l")" "$DESTDIR/usr/include/ncurses"
    ln -s "../$(basename "$l")" "$DESTDIR/usr/include/ncursesw"
done
