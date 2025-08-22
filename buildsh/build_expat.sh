#!/bin/bash

ver=2.7.1

if [[ ! -f /home/lixq/src/expat-${ver}.tar.xz ]]; then
    echo "wget https://github.com/libexpat/libexpat/releases/download/R_${ver//./_}/expat-${ver}.tar.xz"
    exit 1
fi

extradirs=(/home/lixq/toolchains/gcc /home/lixq/toolchains/binutils)
pat=""
inc=""
ldl=""
ldr=""
for dir in "${extradirs[@]}"; do
    [[ -d $dir/bin ]] && pat="$pat:$dir/bin"
    [[ -d $dir/include ]] && inc="$inc -I$dir/include"
    if [[ -d $dir/lib64 ]]; then
        ldl="$ldl -L$dir/lib64"
        ldr="$ldr:$dir/lib64"
    elif [[ -d $dir/lib ]]; then
        ldl="$ldl -L$dir/lib"
        ldr="$ldr:$dir/lib"
    fi
done
pat="${pat#:}"
inc="${inc# }"
ldl="${ldl# }"
ldr="${ldr#:}"
export PATH="$pat:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export CC="/home/lixq/toolchains/gcc/bin/gcc"
export CXX="/home/lixq/toolchains/gcc/bin/g++"
export CCAS="/home/lixq/toolchains/gcc/bin/gcc"
export CPP="/home/lixq/toolchains/gcc/bin/cpp"
export CFLAGS="$inc"
export CXXFLAGS="$inc"
export LDFLAGS="$ldl -Wl,-rpath-link=$ldr -Wl,-rpath=$ldr"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf expat-${ver}
tar -xf /home/lixq/src/expat-${ver}.tar.xz
cd expat-${ver} || exit 1
./configure --prefix=/home/lixq/toolchains/expat-${ver} || exit 1
make || exit 1
rm -rf /home/lixq/toolchains/expat-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/expat-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f expat
    ln -s expat-${ver} expat
fi
