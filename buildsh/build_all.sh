#!/bin/bash
sdir="$(dirname "${BASH_SOURCE[0]}")"

function build_packages() {
    ver=$1
    shift
    DESTDIR=$1
    shift
    pkgs=("$@")
    [[ -f "$DESTDIR-$ver.tar.gz" ]] && return
    rm -rf "$DESTDIR"
    tsb=$(date +%s)
    date "+%Y-%m-%d %H:%M:%S begin $DESTDIR ${pkgs[*]}" | tee -a /tmp/build_all.log
    for p in "${pkgs[@]}"; do
        date "+%Y-%m-%d %H:%M:%S begin build $DESTDIR $p" | tee -a /tmp/build_all.log
        tb=$(date +%s)
        "$sdir/build_$p.sh" "$DESTDIR" || exit 1
        te=$(date +%s)
        date "+%Y-%m-%d %H:%M:%S end   build $DESTDIR $p use $((te - tb)) seconds" | tee -a /tmp/build_all.log
    done
    cd "$(dirname "$DESTDIR")" || exit 1
    tar -czf "$(basename "$DESTDIR")-$ver.tar.gz" "$(basename "$DESTDIR")"
    tse=$(date +%s)
    date "+%Y-%m-%d %H:%M:%S end   $DESTDIR ${pkgs[*]} use $((tse - tsb)) seconds" | tee -a /tmp/build_all.log
}

tab=$(date +%s)
date "+%Y-%m-%d %H:%M:%S begin" | tee /tmp/build_all.log

# gcc     15.2.0  https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/
# ./contrib/download_prerequisites  https://gcc.gnu.org/pub/gcc/infrastructure/
# binutils  2.45  https://mirrors.tuna.tsinghua.edu.cn/gnu/binutils/
gccver=15.2.0
build_packages $gccver /opt/gcc gcc binutils
build_packages $gccver /home/lixq/toolchains/gcc gcc binutils

# cmake  4.1.0  https://cmake.org/download/
build_packages  4.1.0  /home/lixq/toolchains/cmake cmake

# Bear   3.1.6  https://github.com/rizsotto/Bear/
build_packages 4.1.0 /home/lixq/toolchains/Bear Bear

# bashdb  4.4-1.0.1  https://sourceforge.net/projects/bashdb/files/bashdb/
build_packages 4.4-1.0.1 /home/lixq/toolchains/bashdb bashdb

# bat  0.25.0  https://github.com/sharkdp/bat/releases/
build_packages 0.25.0 /home/lixq/toolchains/bat bat

# make             4.4.1   https://mirrors.tuna.tsinghua.edu.cn/gnu/make/
# patchelf         0.18.0  https://github.com/NixOS/patchelf/releases/
# pcre2            10.45   https://github.com/PCRE2Project/pcre2/releases/
# audit-userspace  4.1.1   https://github.com/linux-audit/audit-userspace/releases/
# libcap           2.76    https://git.kernel.org/pub/scm/libs/libcap/libcap.git/snapshot/
# glibc            2.42    https://mirrors.ustc.edu.cn/gnu/glibc/
# libselinux       3.9     https://github.com/SELinuxProject/selinux/tags
build_packages 4.4.1 /home/lixq/toolchains/make make
build_packages 0.18.0 /home/lixq/toolchains/patchelf patchelf
build_packages 2.42 /home/lixq/toolchains/glibc pcre2 audit-userspace libcap glibc libselinux

# openssl       3.5.2   https://github.com/openssl/openssl/releases/
# nghttp3       1.11.0  https://github.com/ngtcp2/nghttp3/releases/
# ngtcp2        1.14.0  https://github.com/ngtcp2/ngtcp2/releases/
# nghttp2       1.66.0  https://github.com/nghttp2/nghttp2/releases/
# libssh2       1.11.1  https://libssh2.org/
# zlib          1.3.1   https://github.com/madler/zlib/releases/
# brotli        1.1.0   https://github.com/google/brotli/releases/
# zstd          1.5.7   https://github.com/facebook/zstd/releases/
# keyutils      1.6.3   https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/
# krb5          1.22.1  https://web.mit.edu/kerberos/dist/
# libidn2       2.3.8   https://mirrors.tuna.tsinghua.edu.cn/gnu/libidn/
# openldap      2.6.10  https://www.openldap.org/software/download/
# libunistring  1.3     https://mirrors.tuna.tsinghua.edu.cn/gnu/libunistring/
# libpsl        0.21.5  https://github.com/rockdaboot/libpsl/releases/
# gsasl         2.2.2   https://mirrors.tuna.tsinghua.edu.cn/gnu/gsasl/
# curl          8.15.0  https://github.com/curl/curl/releases/
build_packages 8.15.0 /home/lixq/toolchains/curl openssl nghttp3 ngtcp2 nghttp2 # libssh2 zlib brotli zstd keyutils krb5 libidn2 openldap libunistring libpsl gsasl curl

tae=$(date +%s)
date "+%Y-%m-%d %H:%M:%S end   use $((tae - tab)) seconds" | tee -a /tmp/build_all.log

# # bzip2       1.0.8   https://sourceware.org/pub/bzip2/
# # Linux-PAM   1.17.1  https://github.com/linux-pam/linux-pam/releases/
# # libcap-ng   0.8.5   https://github.com/stevegrubb/libcap-ng/releases/


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
# # gdb         16.3      https://mirrors.tuna.tsinghua.edu.cn/gnu/gdb/
# # git         2.51.0    https://github.com/git/git/tags
# # Shellcheck  0.11.0    https://github.com/koalaman/shellcheck/releases
# # boost       1.89.0    https://www.boost.org/releases/latest/
# # tcpflow     1.6.1     https://github.com/simsong/tcpflow/releases/
# # zsh         5.9       https://www.zsh.org/
# 
# n=6
# [[ -f /home/lixq/mintoolset.tar.$n ]] || cp /home/lixq/mintoolset.tar.$((n-1)) /home/lixq/mintoolset.tar.$n
# build_packages $n bashdb bat gdb shellcheck boost tcpflow zsh git patchelf

