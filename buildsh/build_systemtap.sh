#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=5.3
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="$DESTDIR/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export CPATH="/home/lixq/toolchains/boost_1_88_0/usr/include:$DESTDIR/usr/include"
export LIBRARY_PATH="/home/lixq/toolchains/boost_1_88_0/usr/lib:$DESTDIR/usr/lib"
export LDFLAGS="-L/home/lixq/toolchains/boost_1_88_0/usr/lib -L$DESTDIR/usr/lib -Wl,-rpath-link,$LIBRARY_PATH"
export LD_RUN_PATH="$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
./configure "--prefix=$DESTDIR/usr" || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install || exit 1

[[ -d $DESTDIR/usr/lib ]] || mkdir -p "$DESTDIR/usr/lib"
[[ -f $DESTDIR/usr/lib/libboost_system.so.1.88.0 ]] || cp /home/lixq/toolchains/boost_1_88_0/usr/lib/libboost_system.so.1.88.0 "$DESTDIR/usr/lib/libboost_system.so.1.88.0"
for f in "$DESTDIR/usr/bin/stap" "$DESTDIR/usr/bin/stapbpf" "$DESTDIR/usr/bin/stap-merge" "$DESTDIR/usr/bin/staprun" "$DESTDIR/usr/bin/stapsh" "$DESTDIR/usr/libexec/systemtap/stapio"; do
    patchelf --set-interpreter "$DESTDIR/lib64/ld-linux-x86-64.so.2" "$f"
done

sed "s;/home/lixq/toolchains/systemtap;$DESTDIR;" "$(dirname "${BASH_SOURCE[0]}")/stap.sh" > "$DESTDIR/usr/bin/stap.sh"
chmod 755 "$DESTDIR/usr/bin/stap.sh"
