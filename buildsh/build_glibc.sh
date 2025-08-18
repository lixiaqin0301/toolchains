#!/bin/bash

ver=2.42
kver=6.6
DESTDIR=/home/lixq/toolchains/glibc-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

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

if [[ ! -d "${DESTDIR}" ]]; then
    export PATH="/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/binutils/bin:/home/lixq/toolchains/make/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
    . "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" "$(basename "$DESTDIR")"
    export PATH="/home/lixq/toolchains/make/bin:$PATH"
    export CFLAGS="-O2 $CFLAGS"
    export CXXFLAGS="-O2 $CXXFLAGS"
fi

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf glibc-${ver}
tar -xf /home/lixq/35share-rd/src/glibc-${ver}.tar.xz
mkdir -p /home/lixq/src/glibc-${ver}/glibc-${ver}/build/glibc
cd /home/lixq/src/glibc-${ver}/glibc-${ver}/build/glibc || exit 1
/home/lixq/src/glibc-${ver}/configure --prefix=/usr || exit 1
make -s -j"$(nproc)" || exit 1
[[ "${DESTDIR}" == */glibc* ]] && rm -rf "${DESTDIR}"
make -s -j"$(nproc)" install DESTDIR="${DESTDIR}" || exit 1
if [[ "$(basename "$(dirname "$DESTDIR")")" != mintoolset ]]; then
    make -s -j"$(nproc)" localedata/install-locales DESTDIR="${DESTDIR}" || exit 1
    make -s -j"$(nproc)" localedata/install-locale-files DESTDIR="${DESTDIR}" || exit 1
fi

cd /home/lixq/src || exit 1
rm -rf linux-${kver}
tar -xf /home/lixq/35share-rd/src/linux-${kver}.tar.xz
cd /home/lixq/src/linux-${kver} || exit 1
make headers_install INSTALL_HDR_PATH="${DESTDIR}/usr" || exit 1

cd "${DESTDIR}/lib64" || exit 1
for p in /home/lixq/toolchains/gcc/lib64/libstdc++.s*[0-9o]; do
    [[ -L "$p" ]] || cp "$p" .
    [[ -L "$p" ]] && ln -sf "$(readlink "$p")" "$(basename "$p")"
done
cp /home/lixq/toolchains/gcc/lib64/libgcc* .

if [[ "$(basename "${DESTDIR}")" == glibc-${ver} ]]; then
    cd "${DESTDIR}" || exit 1
    cd .. || exit 1
    rm -f glibc
    ln -s glibc-${ver} glibc
fi
