#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=2.44
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
kernelver=6.6.145
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]
[[ -f /home/lixq/src/linux-$kernelver.tar.xz ]]

export PATH="/home/lixq/toolchains/make/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

cd /home/lixq/src
rm -rf "$name-$ver" linux-${kernelver}
tar -xf "$srcpath"
mkdir -p "$name-$ver/$name-$ver/build/glibc"
cd "/home/lixq/src/$name-$ver/$name-$ver/build/glibc"

if [[ $DESTDIR == /opt/glibc ]]; then
    ../../../configure --prefix="$DESTDIR"
    make -s "-j$(nproc)"
    rm -rf "$DESTDIR"
    make -s "-j$(nproc)" install
    cd "$DESTDIR/lib"
    for p in /home/lixq/toolchains/gcc/usr/lib64/libgcc* /home/lixq/toolchains/gcc/usr/lib64/libstdc++.s*[0-9o]; do
        [[ -f $(basename "$p") ]] && continue
        if [[ -L $p ]]; then
            ln -sf "$(readlink "$p")" "$(basename "$p")"
        else
            cp "$p" .
        fi
    done
    cd /opt
    rm -rf glibc-$ver.el7.tar.gz
    tar -czf glibc-$ver.el7.tar.gz "$(basename "$DESTDIR")"
    exit 0
fi

../../../configure --prefix=/usr
make -s "-j$(nproc)"
make -s "-j$(nproc)" install "DESTDIR=$DESTDIR"
# make -s "-j$(nproc)" localedata/install-locales "DESTDIR=$DESTDIR"
# make -s "-j$(nproc)" localedata/install-locale-files "DESTDIR=$DESTDIR"
cd /home/lixq/src
rm -rf linux-$kernelver
tar -xf /home/lixq/src/linux-$kernelver.tar.xz
cd /home/lixq/src/linux-${kernelver}
make -s "-j$(nproc)" headers_install "INSTALL_HDR_PATH=$DESTDIR/usr"
