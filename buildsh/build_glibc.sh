#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=2.42
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
kernelver=6.6

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1
[[ -f /home/lixq/src/linux-$kernelver.tar.xz ]] || exit 1

export PATH="/home/lixq/toolchains/patchelf/usr/bin:/home/lixq/toolchains/make/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export LDFLAGS="-static-libgcc -static-libstdc++"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver" linux-${kernelver}
tar -xf "$srcpath" || exit 1
mkdir -p "/home/lixq/src/$name-$ver/$name-$ver/build/glibc"
cd "/home/lixq/src/$name-$ver/$name-$ver/build/glibc" || exit 1
"/home/lixq/src/$name-$ver/configure" --prefix=/usr || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install "DESTDIR=$DESTDIR" || exit 1
if [[ $DESTDIR != */mintoolset ]]; then
    make -s "-j$(nproc)" localedata/install-locales "DESTDIR=$DESTDIR" || exit 1
    make -s "-j$(nproc)" localedata/install-locale-files "DESTDIR=$DESTDIR" || exit 1
    cd /home/lixq/src || exit 1
    rm -rf linux-$kernelver
    tar -xf /home/lixq/src/linux-$kernelver.tar.xz || exit 1
    cd /home/lixq/src/linux-${kernelver} || exit 1
    make -s "-j$(nproc)" headers_install "INSTALL_HDR_PATH=$DESTDIR/usr" || exit 1
else
    cd "$DESTDIR/lib64" || exit 1
    cp /home/lixq/toolchains/gcc/usr/lib64/libgcc* .
    for p in /home/lixq/toolchains/gcc/usr/lib64/libstdc++.s*[0-9o]; do
        if [[ -L "$p" ]]; then
            ln -sf "$(readlink "$p")" "$(basename "$p")"
        else
            cp "$p" .
        fi
    done
fi

for f in "$DESTDIR"/usr/*bin/* "$DESTDIR"/*bin/*; do
    [[ -L $f ]] && continue
    ldd "$f" 2>&1 | grep -q ': version .GLIBC_.* not found' || continue
    patchelf --set-rpath "$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib" "$f"
    file "$f" | grep -q 'uses shared libs' || continue
    patchelf --set-interpreter "$DESTDIR/lib64/ld-linux-x86-64.so.2" "$f"
done
