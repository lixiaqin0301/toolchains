#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=1.23.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/lib64/pkgconfig:$DESTDIR/usr/lib64/pkgconfig:$DESTDIR/lib/pkgconfig:$DESTDIR/usr/lib/pkgconfig"
export CPATH="$DESTDIR/usr/include"
export LIBRARY_PATH="$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "$name-$ver"
autoreconf -fi
./configure --prefix="$DESTDIR"/usr --with-openssl
for p in "crypto/ossl/\$(top_srcdir)/tests/munit/.deps/cryptotest-munit.Po" \
         "examples/\$(top_srcdir)/tests/munit/.deps/examplestest-munit.Po"; do
    f=$(basename "$p")
    [[ -f "tests/munit/.deps/$f" ]] && continue
    cp "$p" tests/munit/.deps/
done
make -s "-j$(nproc)"
make -s "-j$(nproc)" install
