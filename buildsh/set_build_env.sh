#!/bin/bash
if [[ "$1" == toolset || "$1" == mintoolset ]]; then
    export PATH="/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/binutils/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    #export PKG_CONFIG_PATH=
    export CC="/home/lixq/toolchains/gcc/bin/gcc"
    export CXX="/home/lixq/toolchains/gcc/bin/g++"
    export CFLAGS="--sysroot=/home/lixq/$1"
    export CXXFLAGS="--sysroot=/home/lixq/$1"
    export LDFLAGS="-L/home/lixq/$1/lib64 -L/home/lixq/$1/usr/lib64 --sysroot=/home/lixq/$1 -Wl,-rpath-link,/home/lixq/$1/lib64:/home/lixq/$1/usr/lib64 -Wl,-rpath,/home/lixq/$1/lib64:/home/lixq/$1/usr/lib64 -Wl,--dynamic-linker=/home/lixq/$1/lib64/ld-linux-x86-64.so.2"
else
    use_gcc=no
    use_glibc=no

    inc=""
    ldl=""
    ldr=""
    pkg=""
    for d in "$@"; do
        if [[ "$d" == toolset ]]; then
            continue
        elif [[ "$d" == gcc ]]; then
            use_gcc=yes
            continue
        elif [[ "$d" == glibc ]]; then
            use_glibc=yes
            continue
        fi
        incdir=""
        libdir=""
        for m in "" /usr /usr/local; do
            [[ -d /home/lixq/toolchains/$d$m/include ]] && incdir=/home/lixq/toolchains/$d$m/include
        done
        for m in "" /usr /usr/local; do
            [[ -d /home/lixq/toolchains/$d$m/lib64 ]] && libdir=/home/lixq/toolchains/$d$m/lib64
        done
        if [[ -z "$libidir" ]]; then
            for m in "" /usr /usr/local; do
                [[ -d /home/lixq/toolchains/$d$m/lib ]] && libdir=/home/lixq/toolchains/$d$m/lib
            done
        fi
        [[ -d "$incdir" ]] && inc="$inc -I$incdir"
        if [[ -d "$libdir" ]]; then
            ldl="$ldl -L$libdir"
            ldr="$ldr:$libdir"
            [[ -d $libdir/pkgconfig ]] && pkg=$pkg:$libdir/pkgconfig
        fi
    done
    inc="${inc# }"
    inc="${inc% }"
    ldl="${ldl# }"
    ldl="${ldl% }"
    ldr="${ldr#:}"
    ldr="${ldr%:}"
    pkg="${pkg#:}"
    pkg="${pkg%:}"

    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    if [[ "$use_gcc" == "yes" ]]; then
        export PATH="/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/binutils/bin:$PATH"
        export CC="/home/lixq/toolchains/gcc/bin/gcc"
        export CXX="/home/lixq/toolchains/gcc/bin/g++"
    fi
    export PKG_CONFIG_PATH="$pkg"

    if [[ "$use_glibc" == "yes" ]]; then
        inc="$inc --sysroot=/home/lixq/toolchains/glibc"
        ldl="-L/home/lixq/toolchains/glibc/lib64 -L/home/lixq/toolchains/glibc/usr/lib64 $ldl"
        ldr="/home/lixq/toolchains/glibc/lib64:/home/lixq/toolchains/glibc/usr/lib64:$ldr"
        inc="${inc# }"
        inc="${inc% }"
        ldl="${ldl# }"
        ldl="${ldl% }"
        ldr="${ldr#:}"
        ldr="${ldr%:}"
        pkg="${pkg#:}"
        pkg="${pkg%:}"
        export CFLAGS="$inc"
        export CXXFLAGS="$inc"
        export LDFLAGS="$ldl --sysroot=/home/lixq/toolchains/glibc -Wl,-rpath-link,$ldr -Wl,-rpath,$ldr -Wl,--dynamic-linker=/home/lixq/toolchains/glibc/lib64/ld-linux-x86-64.so.2"
    else
        export CFLAGS="$inc"
        export CXXFLAGS="$inc"
        if [[ -n "$ldl" ]]; then
            export LDFLAGS="$ldl -Wl,-rpath-link,$ldr -Wl,-rpath,$ldr"
        fi
    fi
fi
echo "PATH=$PATH"
echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH"
echo "CC=$CC"
echo "CXX=$CXX"
echo "CFLAGS=$CFLAGS"
echo "CXXFLAGS=$CXXFLAGS"
echo "LDFLAGS=$LDFLAGS"
