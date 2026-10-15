#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=$1
DESTDIR=$2
srcpath=/share-rd/cdn_prd_cache/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export MANPATH=
export PCP_DIR=
export LD_LIBRARY_PATH=
export PKG_CONFIG_PATH=
export INFOPATH=
export PATH="/home/lixq/toolchains/cmake/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib64/pkgconfig:$DESTDIR/usr/lib/pkgconfig"
export CPPFLAGS="-I$DESTDIR/usr/include"
export LDFLAGS="-L$DESTDIR/usr/lib64 -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/usr/lib64:$DESTDIR/usr/lib -Wl,-rpath,$DESTDIR/usr/lib64:$DESTDIR/usr/lib"

mkdir -p "$DESTDIR/usr/lib64"
cd "$DESTDIR/usr/lib64"
for p in /home/lixq/toolchains/gcc/usr/lib64/libgcc* /home/lixq/toolchains/gcc/usr/lib64/libstdc++.s*[0-9o]; do
    [[ -f $(basename "$p") ]] && continue
    if [[ -L $p ]]; then
        ln -sf "$(readlink "$p")" "$(basename "$p")"
    else
        cp "$p" .
    fi
done

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
mkdir "$name-$ver/out"
cd "/home/lixq/src/$name-$ver/out"
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$DESTDIR"/usr ..
cmake --build . --config Release -j"$(nproc)"
cmake --install . --config Release
