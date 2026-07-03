#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=0.37.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-src-with-submodule-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export PATH="$DESTDIR/usr/bin:/home/lixq/toolchains/cmake/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/lib64/pkgconfig:$DESTDIR/usr/lib64/pkgconfig:$DESTDIR/usr/lib/pkgconfig"
export CPPFLAGS="--sysroot=$DESTDIR"
export CFLAGS="--sysroot=$DESTDIR"
export CXXFLAGS="--sysroot=$DESTDIR"
export LDFLAGS="-L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -L$DESTDIR/lib -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib --sysroot=$DESTDIR -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"
export LIBRARY_PATH="$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

"$DESTDIR/usr/bin/pip3" install setuptools dnslib cachetools pyelftools systemd
cd /home/lixq/src
rm -rf "$name-src-with-submodule-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-src-with-submodule-$ver/bcc"
#sed -i "1a set(REVISION \"$ver\")" cmake/version.cmake
#sed -i 's/ -bgd / -bg /' src/lua/CMakeLists.txt
mkdir bcc-build
cd "/home/lixq/src/$name-src-with-submodule-$ver/bcc/bcc-build" || exit 1
cmake -DENABLE_LLVM_SHARED=0 -DLLVM_ROOT=/home/lixq/toolchains/llvm/usr \
    -DCMAKE_INSTALL_PREFIX="$DESTDIR" \
    -DCMAKE_INCLUDE_PATH="$DESTDIR/usr/include" \
    -DCMAKE_LIBRARY_PATH="$DESTDIR/usr/lib" \
    -DLibEdit_INCLUDE_DIRS="$DESTDIR/usr/include" \
    -DLibEdit_LIBRARIES="$DESTDIR/usr/lib/libedit.a" \
    -DZLIB_ROOT="$DESTDIR/usr" \
    -DLIBXML2_INCLUDE_DIR="$DESTDIR/usr/include/libxml2" \
    -DLIBXML2_LIBRARY="$DESTDIR/usr/lib/libxml2.a" \
    -DCMAKE_USE_LIBBPF_PACKAGE=1 \
    -DLibBpf_ROOT="$DESTDIR/usr" \
    ..
make -s -j"$(nproc)"
make -s -j"$(nproc)" install
cd "/home/lixq/src/${name}-src-with-submodule-${ver}/bcc/bcc-build/src/python/bcc-python3"
"$DESTDIR/usr/bin/python3" setup.py install
for f in "$DESTDIR/share/bcc/tools/"*; do
    [[ -f $f ]] || continue
    sed -i "s;/usr/bin/env python.*;$DESTDIR/usr/bin/python3;" "$f"
done
