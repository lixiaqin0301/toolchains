#!/bin/bash
use_glibc="no"
pat=""
pkg=""
inc=""
ldl=""
ldr=""
for dir in "$@"; do
    if [[ "$(realpath "$dir")" == "$(realpath /home/lixq/toolchains/glibc)" ]]; then
        pat="$pat:/home/lixq/toolchains/glibc/usr/sbin:/home/lixq/toolchains/glibc/usr/bin:/home/lixq/toolchains/glibc/sbin"
        use_glibc="yes"
        continue
    fi
    [[ -d $dir/bin ]] && pat="$pat:$dir/bin"
    [[ -d $dir/include ]] && inc="$inc -I$dir/include"
    if [[ -d $dir/lib64 ]]; then
        ldl="$ldl -L$dir/lib64"
        ldr="$ldr:$dir/lib64"
        [[ -d "$dir/lib64/pkgconfig" ]] && pkg="$pkg:$dir/lib64/pkgconfig"
    elif [[ -d $dir/lib ]]; then
        ldl="$ldl -L$dir/lib"
        ldr="$ldr:$dir/lib"
        [[ -d "$dir/lib/pkgconfig" ]] && pkg="$pkg:$dir/lib/pkgconfig"
    fi
done
pat="${pat#:}"
pkg="${pkg#:}"
inc="${inc# }"
if [[ "$use_glibc" == "yes" ]]; then
    inc="$inc --sysroot=/home/lixq/toolchains/glibc"
    ldl="-L/home/lixq/toolchains/glibc/lib64 $ldl"
    ldr="/home/lixq/toolchains/glibc/lib64:$ldr"
fi

ldl="${ldl# }"
ldr="${ldr#:}"
if [[ -z "$pat" ]]; then
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
else
    export PATH="$pat:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
fi
export PKG_CONFIG_PATH="$pkg"
export CC="/home/lixq/toolchains/gcc/bin/gcc"
export CXX="/home/lixq/toolchains/gcc/bin/g++"
export CCAS="/home/lixq/toolchains/gcc/bin/gcc"
export CPP="/home/lixq/toolchains/gcc/bin/cpp"
export CFLAGS="$inc"
export CXXFLAGS="$inc"
if [[ "$use_glibc" == "yes" ]]; then
    export LDFLAGS="$ldl --sysroot=/home/lixq/toolchains/glibc -Wl,-rpath-link=$ldr -Wl,-rpath=$ldr -Wl,--dynamic-linker=/home/lixq/toolchains/glibc/lib64/ld-linux-x86-64.so.2"
else
    export LDFLAGS="$ldl -Wl,-rpath-link=$ldr -Wl,-rpath=$ldr"
fi
