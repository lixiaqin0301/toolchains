#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=0.36.1
DESTDIR=$1
srcpath=/home/lixq/src/$name-src-with-submodule-$ver.tar.gz

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1

export PATH="/home/lixq/toolchains/patchelf/usr/bin:/home/lixq/toolchains/cmake/usr/bin:$DESTDIR/usr/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig:$DESTDIR/usr/lib64/pkgconfig"
export CPPFLAGS="--sysroot=$DESTDIR"
export CFLAGS="--sysroot=$DESTDIR"
export CXXFLAGS="--sysroot=$DESTDIR"
export LDFLAGS="-L$DESTDIR/usr/lib64 -L$DESTDIR/lib64 -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/usr/lib64:$DESTDIR/lib64:$DESTDIR/usr/lib --sysroot=$DESTDIR -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"
export LIBRARY_PATH="$DESTDIR/usr/lib64:$DESTDIR/lib64:$DESTDIR/usr/lib"

"$DESTDIR/usr/bin/pip3" install setuptools || exit 1
[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf "$name-src-with-submodule-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-src-with-submodule-$ver/bcc" || exit 1
sed -i "1a set(REVISION \"$ver\")" cmake/version.cmake
sed -i 's/ -bgd / -bg /' src/lua/CMakeLists.txt
mkdir bcc-build
cd bcc-build || exit 1
cmake .. -DCMAKE_INSTALL_PREFIX="$DESTDIR" \
    "-DCMAKE_INCLUDE_PATH=$DESTDIR/usr/include" \
    "-DCMAKE_LIBRARY_PATH=$DESTDIR/usr/lib" \
    "-DLibEdit_INCLUDE_DIRS=$DESTDIR/usr/include" \
    "-DLibEdit_LIBRARIES=$DESTDIR/usr/lib/libedit.a" \
    "-DZLIB_ROOT=$DESTDIR/usr" \
    "-DLIBXML2_INCLUDE_DIR=$DESTDIR/usr/include/libxml2" \
    "-DLIBXML2_LIBRARY=$DESTDIR/usr/lib/libxml2.a" \
    -DENABLE_LLVM_SHARED=0 -DLLVM_ROOT=/home/lixq/toolchains/llvm/usr \
    -DCMAKE_USE_LIBBPF_PACKAGE=1 "-DLibBpf_ROOT=$DESTDIR/usr"
make -s -j"$(nproc)" || exit 1
make -s -j"$(nproc)" install || exit 1
cd "/home/lixq/src/${name}-src-with-submodule-${ver}/bcc/bcc-build/src/python/bcc-python3" || exit 1
"$DESTDIR/usr/bin/python3" setup.py install || exit 1
for f in "$DESTDIR/share/bcc/tools/"*; do
    [[ -f $f ]] || continue
    sed -i "s;/usr/bin/env python.*;$DESTDIR/usr/bin/python3;" "$f"
done
