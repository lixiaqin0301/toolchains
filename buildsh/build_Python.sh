#!/bin/bash

ver=3.13.6
DESTDIR=/home/lixq/toolchains/Python-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/src/Python-${ver}.tar.xz ]]; then
    echo "wget https://www.python.org/ftp/python/${ver}/Python-${ver}.tar.xz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc "${DESTDIR%-*}"
export PATH="/home/lixq/toolchains/binutils/bin:$PATH"
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf Python-${ver}
tar -xf /home/lixq/src/Python-${ver}.tar.xz
cd /home/lixq/src/Python-${ver} || exit 1
./configure --prefix="${DESTDIR}" --enable-shared || exit 1
make -s -j"$(nproc)" || exit 1
rm -rf "${DESTDIR}"
make install || exit 1
cd "${DESTDIR}" || exit 1
if [[ "${DESTDIR}" == "/home/lixq/toolchains/Python-${ver}" ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f Python
    ln -s Python-${ver} Python
fi
