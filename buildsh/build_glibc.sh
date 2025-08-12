#!/bin/bash

ver=2.42
kver=6.6
if [[ ! -f /home/lixq/35share-rd/src/glibc-${ver}.tar.xz ]]; then
    echo "wget https://mirrors.ustc.edu.cn/gnu/glibc/glibc-${ver}.tar.xz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/linux-${kver}.tar.xz ]]; then
    echo "wget https://mirrors.tuna.tsinghua.edu.cn/kernel/v$(echo ${kver} | awk -F '.' '{print $1}').x/linux-${kver}.tar.xz"
    need_exit=yes
fi
if [[ "$need_exit" == yes ]]; then
    exit 1
fi

DESTDIR=/home/lixq/toolchains/glibc-${ver}
[[ -n "$1" ]] && DESTDIR="$1"
export PATH="/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/binutils/bin:/home/lixq/toolchains/make/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf glibc-${ver}
tar -xf /home/lixq/35share-rd/src/glibc-${ver}.tar.xz
mkdir -p /home/lixq/src/glibc-${ver}/glibc-${ver}/build/glibc
cd /home/lixq/src/glibc-${ver}/glibc-${ver}/build/glibc || exit 1
/home/lixq/src/glibc-${ver}/configure --prefix=/usr || exit 1
make -j"$(nproc)" || exit 1
rm -rf "${DESTDIR}"
make install DESTDIR="${DESTDIR}" || exit 1
make -j"$(nproc)" localedata/install-locales DESTDIR="${DESTDIR}" || exit 1
make -j"$(nproc)" localedata/install-locale-files DESTDIR="${DESTDIR}" || exit 1

cd /home/lixq/src || exit 1
rm -rf linux-${kver}
tar -xf /home/lixq/35share-rd/src/linux-${kver}.tar.xz
cd /home/lixq/src/linux-${kver} || exit 1
make headers_install INSTALL_HDR_PATH="${DESTDIR}/usr" || exit 1

if [[ -d "${DESTDIR}" ]]; then
    if [[ "${DESTDIR}" == "/home/lixq/toolchains/glibc-${ver}" ]]; then
        cd /home/lixq/toolchains || exit 1
        rm -f glibc
        ln -s glibc-${ver} glibc
        for f in /home/lixq/toolchains/glibc/usr/sbin/* /home/lixq/toolchains/glibc/usr/bin/* /home/lixq/toolchains/glibc/sbin/*; do
            if ldd "$f" | grep " /lib64/libc.so.6"; then
                /home/lixq/toolchains/patchelf/bin/patchelf --set-rpath /home/lixq/toolchains/glibc/lib64:/home/lixq/toolchains/gcc/lib64:/lib64 "$f"
                /home/lixq/toolchains/patchelf/bin/patchelf --set-interpreter /home/lixq/toolchains/glibc/lib64/ld-linux-x86-64.so.2 "$f"
            fi
        done
    else
        for f in "${DESTDIR}"/usr/sbin/* "${DESTDIR}"/usr/bin/* "${DESTDIR}"/sbin/*; do
            if ldd "$f" | grep " /lib64/libc.so.6"; then
                /home/lixq/toolchains/patchelf/bin/patchelf --set-rpath "${DESTDIR}/lib64:/lib64" "$f"
                /home/lixq/toolchains/patchelf/bin/patchelf --set-interpreter "${DESTDIR}/lib64/ld-linux-x86-64.so.2" "$f"
            fi
        done
    fi
    cd "${DESTDIR}/lib64" || exit 1
    for p in /home/lixq/toolchains/gcc/lib64/libstdc++.s*[0-9o]; do
        [[ -L "$p" ]] || cp "$p" .
        [[ -L "$p" ]] && ln -s "$(readlink "$p")" "$(basename "$p")"
    done
    cp /home/lixq/toolchains/gcc/lib64/libgcc* .
fi
