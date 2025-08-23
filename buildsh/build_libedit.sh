#!/bin/bash

ver=20250104-3.1
DESTDIR=/home/lixq/toolchains/libedit-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/src/libedit-${ver}.tar.gz ]]; then
    echo "wget https://thrysoee.dk/editline/libedit-${ver}.tar.gz"
    exit 1
fi

#. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" /home/lixq/toolchains/gcc
#export PATH="/home/lixq/toolchains/binutils/bin:$PATH"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf libedit-${ver}
tar -xf /home/lixq/src/libedit-${ver}.tar.gz
cd /home/lixq/src/libedit-${ver} || exit 1
./configure --prefix="${DESTDIR}" || exit 1
make -s -j"$(nproc)" || exit 1
rm -rf "${DESTDIR}"
make install || exit 1
cd "${DESTDIR}" || exit 1
if [[ "${DESTDIR}" == "/home/lixq/toolchains/libedit-${ver}" ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f libedit
    ln -s libedit-${ver} libedit
fi
