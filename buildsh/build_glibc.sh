#!/bin/bash

ver=2.41
kver=4.20.17
DESTDIR=/home/lixq/toolchains/glibc-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable

need_exit=no
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
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src

cd /home/lixq/src || exit 1
rm -rf glibc-${ver}
tar -xf /home/lixq/35share-rd/src/glibc-${ver}.tar.xz
mkdir -p glibc-${ver}/build/glibc
cd glibc-${ver}/build/glibc || exit 1
/home/lixq/src/glibc-${ver}/configure --prefix=/usr || exit 1
make -j32 || exit 1
#make check || exit 1
rm -rf "${DESTDIR}"
make install DESTDIR="${DESTDIR}" || exit 1
make localedata/install-locales DESTDIR="${DESTDIR}" || exit 1
make localedata/install-locale-files DESTDIR="${DESTDIR}" || exit 1

cd /home/lixq/src || exit 1
rm -rf linux-${kver}
tar -xf /home/lixq/35share-rd/src/linux-${kver}.tar.xz
cd linux-${kver} || exit 1
make headers_install INSTALL_HDR_PATH="${DESTDIR}/usr" || exit 1

if [[ -d "${DESTDIR}" ]]; then
    if [[ "${DESTDIR}" == "/home/lixq/toolchains/glibc-${ver}" ]]; then
        cd /home/lixq/toolchains || exit 1
        rm -f glibc
        ln -s glibc-${ver} glibc
    fi
    cd "${DESTDIR}/lib64" || exit 1
    for p in /home/lixq/toolchains/gcc/lib64/libstdc++.s*[0-9o]; do
        [[ -L "$p" ]] || cp "$p" .
        [[ -L "$p" ]] && ln -s "$(readlink "$p")" "$(basename "$p")"
    done
    cp /home/lixq/toolchains/gcc/lib64/libgcc* .
fi
