#!/bin/bash

ver=2.42
kernelver=6.6
patchelfver=0.18.0
DESTDIR=/home/lixq/toolchains/glibc-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/glibc-${ver}.tar.xz ]]; then
    echo "wget https://mirrors.ustc.edu.cn/gnu/glibc/glibc-${ver}.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/linux-${kernelver}.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/kernel/v$(echo ${kver} | awk -F '.' '{print $1}').x/linux-${kernelver}.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/patchelf-${patchelfver}-x86_64.tar.gz ]]; then
    echo "wget https://github.com/NixOS/patchelf/releases/download/${patchelfver}/patchelf-${patchelfver}-x86_64.tar.gz"
    need_exit=yes
fi
if [[ "$need_exit" == yes ]]; then
    exit 1
fi

export PATH="/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/binutils/bin:/home/lixq/toolchains/make/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf glibc-${ver}
tar -xf /home/lixq/35share-rd/src/glibc-${ver}.tar.xz
mkdir -p /home/lixq/src/glibc-${ver}/glibc-${ver}/build/glibc
cd /home/lixq/src/glibc-${ver}/glibc-${ver}/build/glibc || exit 1
/home/lixq/src/glibc-${ver}/configure --prefix=/usr || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */glibc-* ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install DESTDIR="$DESTDIR" || exit 1
if [[ "$DESTDIR" != */mintoolset ]]; then
    make -s -j"$(nproc)" localedata/install-locales DESTDIR="$DESTDIR" || exit 1
    make -s -j"$(nproc)" localedata/install-locale-files DESTDIR="$DESTDIR" || exit 1
fi

cd /home/lixq/src || exit 1
rm -rf linux-${kernelver}
tar -xf /home/lixq/35share-rd/src/linux-${kernelver}.tar.xz
cd /home/lixq/src/linux-${kernelver} || exit 1
make -s -j"$(nproc)" headers_install INSTALL_HDR_PATH="$DESTDIR/usr" || exit 1

if [[ "$DESTDIR" == */mintoolset ]]; then
    cd "${DESTDIR}/lib64" || exit 1
    for p in /home/lixq/toolchains/gcc/lib64/libstdc++.s*[0-9o]; do
        [[ -L "$p" ]] || cp "$p" .
        [[ -L "$p" ]] && ln -sf "$(readlink "$p")" "$(basename "$p")"
    done
    cp /home/lixq/toolchains/gcc/lib64/libgcc* .
fi

cd "${DESTDIR}/usr" || exit 1
tar -xf /home/lixq/35share-rd/src/patchelf-${patchelfver}-x86_64.tar.gz || exit 1
for f in "$DESTDIR"/sbin/* "$DESTDIR"/usr/sbin/* "$DESTDIR"/usr/bin/* "$DESTDIR"/lib64/*; do
    if ldd "$f" 2>&1 | grep -q "libc.so.6 => /lib64/libc.so.6"; then
        "$DESTDIR/usr/bin/patchelf" --set-rpath "$DESTDIR/lib64:$DESTDIR/usr/lib64:/lib64" "$f" 
        "$DESTDIR/usr/bin/patchelf" --set-interpreter "$DESTDIR/lib64/ld-linux-x86-64.so.2" "$f"   
    fi
done                                                              

if [[ "$(basename "${DESTDIR}")" == glibc-${ver} ]]; then
    cd "${DESTDIR}" || exit 1
    cd .. || exit 1
    rm -f glibc
    ln -s glibc-${ver} glibc
fi
