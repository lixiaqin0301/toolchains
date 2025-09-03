#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=2.42
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
kernelver=6.6

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1
[[ -f /home/lixq/src/linux-$kernelver.tar.gz ]] || exit 1

export PATH="/home/lixq/toolchains/patchelf/usr/bin:/home/lixq/toolchains/make/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-$ver" linux-${kernelver}
tar -xf "$srcpath" || exit 1
mkdir -p "$name-$ver/$name-$ver/build/glibc"
cd "$name-$ver/$name-$ver/build/glibc" || exit 1
../../../configure --prefix=/usr || exit 1
make -s "-j$(nproc)" || exit 1
make -s "-j$(nproc)" install "DESTDIR=$DESTDIR" || exit 1
if [[ $DESTDIR == */$name ]]; then
    make -s "-j$(nproc)" localedata/install-locales "DESTDIR=$DESTDIR" || exit 1
    make -s "-j$(nproc)" localedata/install-locale-files "DESTDIR=$DESTDIR" || exit 1
# else
#     cd "$DESTDIR/lib64" || exit 1
#     cp /home/lixq/toolchains/gcc/usr/lib64/libgcc* .
#     for p in /home/lixq/toolchains/gcc/usr/lib64/libstdc++.s*[0-9o]; do
#         [[ -f $(basename "$p") ]] && continue
#         if [[ -L $p ]]; then
#             ln -sf "$(readlink "$p")" "$(basename "$p")"
#         else
#             cp "$p" .
#         fi
#     done
fi

cd /home/lixq/src || exit 1
rm -rf linux-$kernelver
tar -xf /home/lixq/src/linux-$kernelver.tar.gz || exit 1
cd linux-${kernelver} || exit 1
make -s "-j$(nproc)" headers_install "INSTALL_HDR_PATH=$DESTDIR/usr" || exit 1

for f in "$DESTDIR"/usr/*bin/* "$DESTDIR"/*bin/* "$DESTDIR"/usr/*lib/* "$DESTDIR"/*lib/*; do
    [[ -L $f ]] && continue
    ldd "$f" | grep ' => ' || continue
    patchelf --set-rpath "$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib" "$f"
    file "$f" | grep 'uses shared libs' || continue
    patchelf --set-interpreter "$DESTDIR/lib64/ld-linux-x86-64.so.2" "$f"
done
