#!/bin/bash

function build_packages() {
    n=$1
    shift
    pkgs=("$@")
    tsb=$(date +%s)
    date "+%Y-%m-%d %H:%M:%S begin step $n ${pkgs[*]}" >> /tmp/build_all.log
    for p in "${pkgs[@]}"; do
        [[ -d /home/lixq/toolchains/$p ]] && continue
        date "+%Y-%m-%d %H:%M:%S begin build toolchains $p" >> /tmp/build_all.log
        tb=$(date +%s)
        "/home/lixq/35share-rd/toolchains/buildsh/build_$p.sh" || exit 1
        if grep -q 'set_build_env.sh.*{name}' "/home/lixq/35share-rd/toolchains/buildsh/build_$p.sh"; then
            "/home/lixq/35share-rd/toolchains/buildsh/build_$p.sh" || exit 1
        fi
        te=$(date +%s)
        date "+%Y-%m-%d %H:%M:%S end   build toolchains $p use $((te - tb)) seconds" >> /tmp/build_all.log
    done
    for td in toolset mintoolset; do
        [[ -f /home/lixq/$td.tar.$n ]] && continue
        rm -rf /home/lixq/$td
        cd /home/lixq || exit 1
        [[ -s $td.tar.$((n-1)) ]] && tar -xf $td.tar.$((n-1))
        for p in "${pkgs[@]}"; do
            date "+%Y-%m-%d %H:%M:%S begin build $td $p" >> /tmp/build_all.log
            tb=$(date +%s)
            "/home/lixq/35share-rd/toolchains/buildsh/build_$p.sh" /home/lixq/$td || exit 1
            te=$(date +%s)
            date "+%Y-%m-%d %H:%M:%S end   build $td $p use $((te - tb)) seconds" >> /tmp/build_all.log
        done
        cd /home/lixq || exit 1
        tar -cf "$td.tar.$n" $td
    done
    tse=$(date +%s)
    date "+%Y-%m-%d %H:%M:%S end   step $n ${pkgs[*]} use $((tse - tsb)) seconds" >> /tmp/build_all.log
}

date "+%Y-%m-%d %H:%M:%S begin" > /tmp/build_all.log
tab=$(date +%s)

DESTDIR=/home/lixq/toolset

# rm -rf /home/lixq/toolset /home/lixq/toolset.tar.1

# date "+%Y-%m-%d %H:%M:%S begin build toolset glibc 1" >> /tmp/build_all.log
# tb=$(date +%s)
# export SET_BUILD_ENV_SETTED=yes
# export PATH="/home/lixq/toolchains/gcc/usr/bin:/home/lixq/toolchains/binutils/usr/bin:/home/lixq/toolchains/make/usr/bin:/home/lixq/toolchains/patchelf/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# export PKG_CONFIG_PATH=""
# export CC="/home/lixq/toolchains/gcc/usr/bin/gcc"
# export CXX="/home/lixq/toolchains/gcc/usr/bin/g++"
# export CFLAGS=""
# export CXXFLAGS=""
# export LDFLAGS=""
# /home/lixq/35share-rd/toolchains/buildsh/build_glibc.sh "$DESTDIR" || exit 1
# te=$(date +%s)
# date "+%Y-%m-%d %H:%M:%S end   build toolset glibc 1 use $((te - tb)) seconds" >> /tmp/build_all.log

# date "+%Y-%m-%d %H:%M:%S begin build toolset pcre2" >> /tmp/build_all.log
# tb=$(date +%s)
# export SET_BUILD_ENV_SETTED=""
# export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# export PKG_CONFIG_PATH=""
# export CC=""
# export CXX=""
# export CFLAGS=""
# export CXXFLAGS=""
# export LDFLAGS=""
# /home/lixq/35share-rd/toolchains/buildsh/build_pcre2.sh "$DESTDIR" || exit 1
# te=$(date +%s)
# date "+%Y-%m-%d %H:%M:%S end   build toolset pcre2 use $((te - tb)) seconds" >> /tmp/build_all.log

# date "+%Y-%m-%d %H:%M:%S begin build toolset bzip2" >> /tmp/build_all.log
# tb=$(date +%s)
# export SET_BUILD_ENV_SETTED=""
# export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# export PKG_CONFIG_PATH=""
# export CC=""
# export CXX=""
# export CFLAGS=""
# export CXXFLAGS=""
# export LDFLAGS=""
# /home/lixq/35share-rd/toolchains/buildsh/build_bzip2.sh "$DESTDIR" || exit 1
# te=$(date +%s)
# date "+%Y-%m-%d %H:%M:%S end   build toolset bzip2 use $((te - tb)) seconds" >> /tmp/build_all.log

# date "+%Y-%m-%d %H:%M:%S begin build toolset audit-userspace" >> /tmp/build_all.log
# tb=$(date +%s)
# export SET_BUILD_ENV_SETTED="yes"
# export PATH="/home/lixq/toolchains/gcc/usr/bin:/home/lixq/toolchains/binutils/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# export PKG_CONFIG_PATH=""
# export CC="/home/lixq/toolchains/gcc/usr/bin/gcc"
# export CXX="/home/lixq/toolchains/gcc/usr/bin/g++"
# export CFLAGS=""
# export CXXFLAGS=""
# export LDFLAGS=""
# /home/lixq/35share-rd/toolchains/buildsh/build_audit-userspace.sh "$DESTDIR" || exit 1
# te=$(date +%s)
# date "+%Y-%m-%d %H:%M:%S end   build toolset audit-userspace use $((te - tb)) seconds" >> /tmp/build_all.log

# date "+%Y-%m-%d %H:%M:%S begin build toolset Linux-PAM" >> /tmp/build_all.log
# tb=$(date +%s)
# export SET_BUILD_ENV_SETTED="yes"
# export PATH="/home/lixq/toolchains/gcc/usr/bin:/home/lixq/toolchains/binutils/usr/bin:/home/lixq/toolchains/Miniforge3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# export PKG_CONFIG_PATH=""
# export CC="/home/lixq/toolchains/gcc/usr/bin/gcc"
# export CXX="/home/lixq/toolchains/gcc/usr/bin/g++"
# export CFLAGS=""
# export CXXFLAGS=""
# export LDFLAGS=""
# /home/lixq/35share-rd/toolchains/buildsh/build_Linux-PAM.sh "$DESTDIR" || exit 1
# te=$(date +%s)
# date "+%Y-%m-%d %H:%M:%S end   build toolset Linux-PAM use $((te - tb)) seconds" >> /tmp/build_all.log

# date "+%Y-%m-%d %H:%M:%S begin build toolset selinux" >> /tmp/build_all.log
# tb=$(date +%s)
# export SET_BUILD_ENV_SETTED=yes
# export PATH="/home/lixq/toolchains/gcc/usr/bin:/home/lixq/toolchains/binutils/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# export PKG_CONFIG_PATH=""
# export CC="/home/lixq/toolchains/gcc/usr/bin/gcc"
# export CXX="/home/lixq/toolchains/gcc/usr/bin/g++"
# export CFLAGS="--sysroot=/home/lixq/toolset"
# export CXXFLAGS="--sysroot=/home/lixq/toolset"
# export LDFLAGS="-L$DESTDIR/lib64 --sysroot=/home/lixq/toolset -Wl,-rpath-link,$DESTDIR/lib64 -Wl,-rpath,$DESTDIR/lib64 -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"
# /home/lixq/35share-rd/toolchains/buildsh/build_selinux.sh "$DESTDIR" || exit 1
# te=$(date +%s)
# date "+%Y-%m-%d %H:%M:%S end   build toolset selinux use $((te - tb)) seconds" >> /tmp/build_all.log

# date "+%Y-%m-%d %H:%M:%S begin build toolset glibc 2" >> /tmp/build_all.log
# tb=$(date +%s)
# export SET_BUILD_ENV_SETTED=yes
# export PATH="/home/lixq/toolchains/gcc/usr/bin:/home/lixq/toolchains/binutils/usr/bin:/home/lixq/toolchains/make/usr/bin:/home/lixq/toolchains/patchelf/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# export PKG_CONFIG_PATH=""
# export CC="/home/lixq/toolchains/gcc/usr/bin/gcc"
# export CXX="/home/lixq/toolchains/gcc/usr/bin/g++"
# export CFLAGS="--sysroot=/home/lixq/toolset -O2"
# export CXXFLAGS="--sysroot=/home/lixq/toolset -O2"
# export LDFLAGS="--sysroot=/home/lixq/toolset"
# /home/lixq/35share-rd/toolchains/buildsh/build_glibc.sh "$DESTDIR" || exit 1
# te=$(date +%s)
# date "+%Y-%m-%d %H:%M:%S end   build toolset glibc 2 use $((te - tb)) seconds" >> /tmp/build_all.log





# date "+%Y-%m-%d %H:%M:%S begin build toolset glibc 3" >> /tmp/build_all.log
# tb=$(date +%s)
# export SET_BUILD_ENV_SETTED=yes
# export PATH="/home/lixq/toolchains/gcc/usr/bin:/home/lixq/toolchains/binutils/usr/bin:/home/lixq/toolchains/make/usr/bin:/home/lixq/toolchains/patchelf/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# export PKG_CONFIG_PATH=""
# export CC="/home/lixq/toolchains/gcc/usr/bin/gcc"
# export CXX="/home/lixq/toolchains/gcc/usr/bin/g++"
# export CFLAGS="--sysroot=/home/lixq/toolset -O2"
# export CXXFLAGS="--sysroot=/home/lixq/toolset -O2"
# export LDFLAGS="-L$DESTDIR/lib64 --sysroot=/home/lixq/toolset -Wl,-rpath-link,$DESTDIR/lib64 -Wl,-rpath,$DESTDIR/lib64 -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"
# /home/lixq/35share-rd/toolchains/buildsh/build_glibc.sh "$DESTDIR" || exit 1
# te=$(date +%s)
# date "+%Y-%m-%d %H:%M:%S end   build toolset glibc 3 use $((te - tb)) seconds" >> /tmp/build_all.log

# export CFLAGS="--sysroot=/home/lixq/toolset -O2"
# export CXXFLAGS="--sysroot=/home/lixq/toolset -O2"
# export LDFLAGS="-L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -L$DESTDIR/usr/lib --sysroot=$DESTDIR -Wl,-rpath-link,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/usr/lib -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/usr/lib -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"
# date "+%Y-%m-%d %H:%M:%S begin build toolset glibc 3" >> /tmp/build_all.log
# tb=$(date +%s)
# /home/lixq/35share-rd/toolchains/buildsh/build_glibc.sh "$DESTDIR" || exit 1
# te=$(date +%s)
# date "+%Y-%m-%d %H:%M:%S end   build toolset glibc 3 use $((te - tb)) seconds" >> /tmp/build_all.log

# for f in "$DESTDIR"/usr/*bin/* "$DESTDIR"/*bin/* "$DESTDIR"/lib*/lib*.so*; do
#     [[ -L "$f" ]] && continue
#     ldd "$f" 2>&1 | grep -q ': version .GLIBC_.* not found' || continue
#     patchelf --set-rpath "$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/usr/lib" "$f"
#     file "$f" | grep -q 'uses shared libs' || continue
#     patchelf --set-interpreter "$DESTDIR"/lib64/ld-linux-x86-64.so.2 "$f"
# done
cd /home/lixq || exit 1
tar -cf toolset.tar.1 toolset
# # step 1 glibc
# # pcre2       10.45  https://github.com/PCRE2Project/pcre2/releases
# # bzip2       1.0.8  https://sourceware.org/pub/bzip2/
# # audit       4.1.1  https://github.com/linux-audit/audit-userspace/releases/
# # libselinux  3.9    https://github.com/SELinuxProject/selinux/tags
# # make        4.4.1  https://mirrors.tuna.tsinghua.edu.cn/gnu/make/
# # glibc       2.42   https://mirrors.ustc.edu.cn/gnu/glibc/
# build_packages 1 glibc

# # step 2 gcc
# # binutils  2.45    https://mirrors.tuna.tsinghua.edu.cn/gnu/binutils/
# # ./contrib/download_prerequisites https://gcc.gnu.org/pub/gcc/infrastructure/
# # gcc       15.2.0  https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/
# n=2
# [[ -f /home/lixq/mintoolset.tar.$n ]] || cp /home/lixq/mintoolset.tar.$((n-1)) /home/lixq/mintoolset.tar.$n
# build_packages $n binutils gcc

# # step 3 cmake Bear
# # cmake  4.1.0  https://cmake.org/download/
# # Bear   3.1.6  https://github.com/rizsotto/Bear/
# n=3
# [[ -f /home/lixq/mintoolset.tar.$n ]] || cp /home/lixq/mintoolset.tar.$((n-1)) /home/lixq/mintoolset.tar.$n
# build_packages $n cmake Bear

# # step 4 curl
# # openssl       3.5.2   https://github.com/openssl/openssl/releases/
# # nghttp3       1.11.0  https://github.com/ngtcp2/nghttp3/releases/
# # ngtcp2        1.14.0  https://github.com/ngtcp2/ngtcp2/releases/
# # nghttp2       1.66.0  https://github.com/nghttp2/nghttp2/releases/
# # libssh2       1.11.1  https://libssh2.org/
# # zlib          1.3.1   https://github.com/madler/zlib/releases/
# # brotli        1.1.0   https://github.com/google/brotli/releases/
# # zstd          1.5.7   https://github.com/facebook/zstd/releases/
# # keyutils      1.6.3   https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/
# # krb5          1.22.1  https://web.mit.edu/kerberos/dist/
# # libidn2       2.3.8   https://mirrors.tuna.tsinghua.edu.cn/gnu/libidn/
# # openldap      2.6.10  https://www.openldap.org/software/download/
# # libunistring  1.3     https://mirrors.tuna.tsinghua.edu.cn/gnu/libunistring/
# # libpsl        0.21.5  https://github.com/rockdaboot/libpsl/releases/
# # gsasl         2.2.2   https://mirrors.tuna.tsinghua.edu.cn/gnu/gsasl/
# # curl          8.15.0  https://github.com/curl/curl/releases/
# build_packages 4 openssl nghttp3 ngtcp2 nghttp2 libssh2 zlib brotli zstd keyutils krb5 libidn2 openldap libunistring libpsl gsasl curl

# # step 5 llvm
# # bison   3.8.2   https://mirrors.tuna.tsinghua.edu.cn/gnu/bison/
# # swig    4.3.1   https://github.com/swig/swig/
# # Python  3.13.7  https://www.python.org/ftp/python/
# # lua     5.4.8   https://www.lua.org/ftp/
# # llvm    20.1.8  https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/
# n=5
# [[ -f /home/lixq/mintoolset.tar.$n ]] || cp /home/lixq/mintoolset.tar.$((n-1)) /home/lixq/mintoolset.tar.$n
# build_packages $n bison swig lua Python llvm

# # step 6 bashdb bat gdb shellcheck tcpflow git
# # bashdb      4.4-1.0.1 https://sourceforge.net/projects/bashdb/files/bashdb/
# # bat         0.25.0    https://github.com/sharkdp/bat/releases/
# # gdb         16.3      https://mirrors.tuna.tsinghua.edu.cn/gnu/gdb/
# # git         2.51.0    https://github.com/git/git/tags
# # Shellcheck  0.11.0    https://github.com/koalaman/shellcheck/releases
# # boost       1.89.0    https://www.boost.org/releases/latest/
# # tcpflow     1.6.1     https://github.com/simsong/tcpflow/releases/
# # zsh         5.9       https://www.zsh.org/
# # patchelf  0.18.0  https://github.com/NixOS/patchelf/releases/
# n=6
# [[ -f /home/lixq/mintoolset.tar.$n ]] || cp /home/lixq/mintoolset.tar.$((n-1)) /home/lixq/mintoolset.tar.$n
# build_packages $n bashdb bat gdb shellcheck boost tcpflow zsh git patchelf

tae=$(date +%s)
date "+%Y-%m-%d %H:%M:%S end   use $((tae - tab)) seconds" >> /tmp/build_all.log
