#!/bin/bash

name=audit-userspace
ver=4.1.1
srcpath=/home/lixq/src/${name}-${ver}.tar.gz
DESTDIR=/home/lixq/toolchains/${name}
[[ -n "$1" ]] && DESTDIR="$1"

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf ${name}-${ver}
tar -xf $srcpath || exit 1
cd ${name}-${ver} || exit 1
autoreconf -fi || exit 1
./configure --prefix="$DESTDIR/usr" --disable-zos-remote --with-python3=no || exit 1
cp -ar "src/test/\${top_srcdir}/src/.deps" 'src/' || exit 1
#cp -ar "bindings/python/python3/\$(top_srcdir)/bindings/python/.deps" "bindings/python" || exit 1
#cp -ar "tools/aulast/test/\${top_srcdir}/tools" 'tools/aulast/test/' || exit 1
make -s -j"$(nproc)" || exit 1
[[ "$DESTDIR" == */${name} ]] && rm -rf "$DESTDIR"
make -s -j"$(nproc)" install || exit 1
