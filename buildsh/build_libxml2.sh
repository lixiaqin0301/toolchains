#!/bin/bash

ver=v2.14.5
DESTDIR=/home/lixq/toolchains/libxml2-${ver}
[[ -n "$1" ]] && DESTDIR="$1"

if [[ ! -f /home/lixq/35share-rd/src/libxml2-${ver}.tar.bz2 ]]; then
    echo "wget https://gitlab.gnome.org/GNOME/libxml2/-/archive/${ver}/libxml2-${ver}.tar.bz2"
    exit 1
fi

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf libxml2-${ver}
tar -xf /home/lixq/35share-rd/src/libxml2-${ver}.tar.bz2
cd /home/lixq/src/libxml2-${ver} || exit 1
sed -i 's;1.16.3;1.13.4;' configure.ac
./autogen.sh || exit 1
./configure --prefix="${DESTDIR}" --enable-static || exit 1
make -s -j"$(nproc)" || exit 1
rm -rf "${DESTDIR}"
make install || exit 1
cd "${DESTDIR}" || exit 1
if [[ "${DESTDIR}" == "/home/lixq/toolchains/libxml2-${ver}" ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f libxml2
    ln -s libxml2-${ver} libxml2
fi
