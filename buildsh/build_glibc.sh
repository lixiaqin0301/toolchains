#!/bin/bash

name=glibc
ver=2.42
srcpath=/home/lixq/src/${name}-${ver}.tar.gz
kernelver=6.6
DESTDIR=/home/lixq/toolchains/glibc
[[ -n "$1" ]] && DESTDIR="$1"

if [[ -z "$CC" ]]; then
    export PATH="/home/lixq/toolchains/gcc/usr/bin:/home/lixq/toolchains/binutils/usr/bin:/home/lixq/toolchains/make/usr/bin:/home/lixq/toolchains/patchelf/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    export CC="/home/lixq/toolchains/gcc/usr/bin/gcc"
    export CXX="/home/lixq/toolchains/gcc/usr/bin/g++"
fi

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf $srcpath || exit 1
mkdir -p /home/lixq/src/${name}-${ver}/${name}-${ver}/build/glibc
cd /home/lixq/src/${name}-${ver}/${name}-${ver}/build/glibc || exit 1
/home/lixq/src/${name}-${ver}/configure --prefix=/usr || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1
if [[ "$DESTDIR" != */mintoolset ]]; then
    make -s -j"$(nproc)" localedata/install-locales DESTDIR="$DESTDIR" || exit 1
    make -s -j"$(nproc)" localedata/install-locale-files DESTDIR="$DESTDIR" || exit 1
fi

cd /home/lixq/src || exit 1
rm -rf linux-${kernelver}
tar -xf /home/lixq/src/linux-${kernelver}.tar.xz
cd /home/lixq/src/linux-${kernelver} || exit 1
make -s -j"$(nproc)" headers_install INSTALL_HDR_PATH="$DESTDIR/usr" || exit 1

if [[ "$DESTDIR" == */mintoolset ]]; then
    cd "$DESTDIR/lib64" || exit 1
    for p in /home/lixq/toolchains/gcc/usr/lib64/libstdc++.s*[0-9o]; do
        [[ -L "$p" ]] || cp "$p" .
        [[ -L "$p" ]] && ln -sf "$(readlink "$p")" "$(basename "$p")"
    done
    cp /home/lixq/toolchains/gcc/usr/lib64/libgcc* .
fi

# for f in "$DESTDIR"/usr/*bin/* "$DESTDIR"/*bin/* "$DESTDIR"/lib*/lib*.so*; do
#     [[ -L "$f" ]] && continue
#     ldd "$f" 2>&1 | grep -q ': version .GLIBC_.* not found' || continue
#     patchelf --set-rpath "$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/usr/lib" "$f"
#     file "$f" | grep -q 'uses shared libs' || continue
#     patchelf --set-interpreter "$DESTDIR"/lib64/ld-linux-x86-64.so.2 "$f"
# done
