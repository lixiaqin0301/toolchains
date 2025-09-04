#!/bin/bash

DESTDIR=/home/lixq/toolchains/systemtap
kerdevdir=/usr/src/kernels/$(uname -r)
kerdevtools=(tools/objtool/objtool scripts/basic/fixdep scripts/mod/modpost)

export PATH="$DESTDIR/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

function recover() {
    [[ -L /usr/bin/gcc ]] && rm -f /usr/bin/gcc
    [[ -f /usr/bin/gcc.bak ]] && mv /usr/bin/gcc.bak /usr/bin/gcc
    for p in "${kerdevtools[@]}"; do
        [[ -f $kerdevdir/$p.bak ]] && mv "$kerdevdir/$p.bak" "$kerdevdir/$p"
    done
}
trap recover EXIT

[[ -f /usr/bin/gcc ]] && mv /usr/bin/gcc /usr/bin/gcc.bak
ln -s "$DESTDIR/usr/bin/gcc" /usr/bin/
for p in "${kerdevtools[@]}"; do
    [[ -f $kerdevdir/$p ]] || continue
    cp -a "$kerdevdir/$p" "$kerdevdir/$p.bak"
    patchelf --set-interpreter "$DESTDIR/lib64/ld-linux-x86-64.so.2" "$kerdevdir/$p"
    patchelf --set-rpath "$DESTDIR/lib64:$DESTDIR/usr/lib" "$kerdevdir/$p"
done

stap "${@}"
