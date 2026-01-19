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

# cmake  4.2.1  https://cmake.org/download/
build_packages 4.2.1 /home/lixq/toolchains/cmake cmake

# Shellcheck  0.11.0  https://github.com/koalaman/shellcheck/releases
build_packages 0.11.0 /home/lixq/toolchains/shellcheck shellcheck

# gcc     15.2.0  https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/
# ./contrib/download_prerequisites  https://gcc.gnu.org/pub/gcc/infrastructure/
# binutils  2.45  https://mirrors.tuna.tsinghua.edu.cn/gnu/binutils/
gccver=15.2.0
build_packages $gccver /opt/gcc gcc binutils
build_packages $gccver /home/lixq/toolchains/gcc gcc binutils

# gdb       17.1  https://mirrors.tuna.tsinghua.edu.cn/gnu/gdb/
# expat    2.7.3  https://github.com/libexpat/libexpat/releases/
# gmp      6.3.0  https://mirrors.tuna.tsinghua.edu.cn/gnu/gmp/
# mpfr     4.2.3  https://mirrors.tuna.tsinghua.edu.cn/gnu/mpfr/
# ncurses    6.3  https://invisible-island.net/ncurses/
# xz       5.8.2  https://tukaani.org/xz/
# zstd     1.5.7  https://github.com/facebook/zstd/releases/
# Python  3.14.2  https://www.python.org/ftp/python/
build_packages 17.1 /home/lixq/toolchains/gdb expat gmp mpfr ncurses xz zstd Python gdb

# Bear  4.0.1  https://github.com/rizsotto/Bear/
#build_packages 4.0.1 /home/lixq/toolchains/Bear Bear
# /mnt/d/update_rust.sh

# bashdb  4.4-1.0.1  https://sourceforge.net/projects/bashdb/files/bashdb/
build_packages 4.4-1.0.1 /home/lixq/toolchains/bashdb bashdb

# bat  0.26.1  https://github.com/sharkdp/bat/releases/
build_packages 0.26.1 /home/lixq/toolchains/bat bat

# make  4.4.1  https://mirrors.tuna.tsinghua.edu.cn/gnu/make/
build_packages 4.4.1 /home/lixq/toolchains/make make

# patchelf  0.18.0  https://github.com/NixOS/patchelf/releases/
build_packages 0.18.0 /home/lixq/toolchains/patchelf patchelf

# glibc            2.42    https://mirrors.ustc.edu.cn/gnu/glibc/
# pcre2            10.46   https://github.com/PCRE2Project/pcre2/releases/
# audit-userspace  4.1.2   https://github.com/linux-audit/audit-userspace/releases/
# libcap           2.76    https://git.kernel.org/pub/scm/libs/libcap/libcap.git/
build_packages 2.42 /home/lixq/toolchains/glibc pcre2 audit-userspace libcap glibc

# curl          8.18.0  https://github.com/curl/curl/releases/
# openssl       3.6.0   https://github.com/openssl/openssl/releases/
# nghttp3       1.14.0  https://github.com/ngtcp2/nghttp3/releases/
# ngtcp2        1.19.0  https://github.com/ngtcp2/ngtcp2/releases/
# nghttp2       1.68.0  https://github.com/nghttp2/nghttp2/releases/
# libssh2       1.11.1  https://libssh2.org/
# zlib          1.3.1   https://github.com/madler/zlib/releases/
# brotli        1.2.0   https://github.com/google/brotli/releases/
# c-ares        1.34.6  https://github.com/c-ares/c-ares/releases/
# zstd          1.5.7   https://github.com/facebook/zstd/releases/
# keyutils      1.6.3   https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/
# krb5          1.22.1  https://web.mit.edu/kerberos/dist/
# libidn2       2.3.8   https://mirrors.tuna.tsinghua.edu.cn/gnu/libidn/
# openldap      2.6.10  https://www.openldap.org/software/download/
# libunistring  1.4.1   https://mirrors.tuna.tsinghua.edu.cn/gnu/libunistring/
# libpsl        0.21.5  https://github.com/rockdaboot/libpsl/releases/
# gsasl         2.2.2   https://mirrors.tuna.tsinghua.edu.cn/gnu/gsasl/
build_packages 8.18.0 /home/lixq/toolchains/curl brotli c-ares gsasl keyutils krb5 libidn2 libpsl libunistring zlib zstd openssl nghttp3 ngtcp2 nghttp2 libssh2 openldap curl

# llvm     21.1.8        https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/
# bison    3.8.2         https://mirrors.tuna.tsinghua.edu.cn/gnu/bison/
# libedit  20251016-3.1  https://thrysoee.dk/editline/
# libxml2  2.15.1        https://gitlab.gnome.org/GNOME/libxml2/-/releases/
# lua      5.4.8         https://www.lua.org/ftp/
# ncurses  6.3           https://invisible-island.net/ncurses/
# swig     4.4.1         https://github.com/swig/swig/tags/
# xz       5.8.2         https://tukaani.org/xz/
# zlib     1.3.1         https://github.com/madler/zlib/releases/
# zstd     1.5.7         https://github.com/facebook/zstd/releases/
# openssl  3.6.0         https://github.com/openssl/openssl/releases/
# Python   3.14.2        https://www.python.org/ftp/python/
build_packages 21.1.8 /home/lixq/toolchains/llvm bison libedit libxml2 lua ncurses swig xz zlib zstd openssl Python llvm

# zsh  5.9  https://www.zsh.org/
build_packages 5.9 /home/lixq/toolchains/zsh zsh

# boost  1.90.0  https://www.boost.org/releases/latest/
build_packages 1.90.0 /home/lixq/toolchains/boost boost

# tcpflow  1.6.1  https://github.com/simsong/tcpflow/releases/
build_packages 1.6.1 /home/lixq/toolchains/tcpflow tcpflow

# git      2.52.0  https://github.com/git/git/tags/
# brotli   1.2.0   https://github.com/google/brotli/releases/
# expat    2.7.3   https://github.com/libexpat/libexpat/releases/
# libpsl   0.21.5  https://github.com/rockdaboot/libpsl/releases/
# zlib     1.3.1   https://github.com/madler/zlib/releases/
# zstd     1.5.7   https://github.com/facebook/zstd/releases/
# openssl  3.6.0   https://github.com/openssl/openssl/releases/
# curl     8.17.0  https://github.com/curl/curl/releases/
# glibc    2.42    https://mirrors.ustc.edu.cn/gnu/glibc/
build_packages 2.52.0 /home/lixq/toolchains/git brotli expat libpsl zlib zstd openssl curl glibc git

# node   25.3.0  https://nodejs.org/dist/
# glibc  2.42    https://mirrors.ustc.edu.cn/gnu/glibc/
build_packages 25.3.0 /home/lixq/toolchains/node glibc node

# bpftrace  0.24.2  https://github.com/bpftrace/bpftrace/releases/
build_packages 0.24.2 /home/lixq/toolchains/bpftrace bpftrace

# bpfsnoop  0.5.3  https://github.com/bpfsnoop/bpfsnoop/tags
build_packages  0.5.3  /home/lixq/toolchains/bpfsnoop bpfsnoop

# bcc       0.35.0         https://github.com/iovisor/bcc/releases/
# bison     3.8.2          https://mirrors.tuna.tsinghua.edu.cn/gnu/bison/
# brotli    1.1.0          https://github.com/google/brotli/releases/
# bzip2     1.0.8          https://sourceware.org/pub/bzip2/
# elfutils  0.193          https://sourceware.org/elfutils/ftp/
# flex      2.6.4          https://github.com/westes/flex/releases/
# icu4c     77.1           https://github.com/unicode-org/icu/
# json-c    0.18-20240915  https://github.com/json-c/json-c/tags
# LuaJIT    2.1.ROLLING    https://github.com/LuaJIT/LuaJIT/tags
# netperf   2.7.0          https://github.com/HewlettPackard/netperf/tags
# libbpf    1.6.2          https://github.com/libbpf/libbpf/releases
# libedit   20251016-3.1   https://thrysoee.dk/editline/
# libffi    3.5.2          https://github.com/libffi/libffi/releases/
# libpsl    0.21.5         https://github.com/rockdaboot/libpsl/releases/
# libxml2   2.15.1         https://gitlab.gnome.org/GNOME/libxml2/-/releases/
# ncurses   6.3            https://invisible-island.net/ncurses/
# openssl   3.6.0          https://github.com/openssl/openssl/releases/
# xz        5.8.2          https://tukaani.org/xz/
# zlib      1.3.1          https://github.com/madler/zlib/releases/
# zstd      1.5.7          https://github.com/facebook/zstd/releases/
# curl      8.16.0         https://github.com/curl/curl/releases/
# glibc     2.42           https://mirrors.ustc.edu.cn/gnu/glibc/
# Python    3.14.2         https://www.python.org/ftp/python/
build_packages 0.35.0 /home/lixq/toolchains/bcc bison brotli bzip2 flex icu4c json-c libbpf libedit libffi libpsl libxml2 LuaJIT ncurses netperf openssl xz zlib zstd curl elfutils glibc Python bcc

# systemtap  5.4     https://sourceware.org/systemtap/ftp/releases/
# binutils   2.45    https://mirrors.tuna.tsinghua.edu.cn/gnu/binutils/
# bzip2      1.0.8   https://sourceware.org/pub/bzip2/
# readline   8.3     https://mirrors.tuna.tsinghua.edu.cn/gnu/readline/
# ncurses    6.3     https://invisible-island.net/ncurses/
# patchelf   0.18.0  https://github.com/NixOS/patchelf/releases/
# xz         5.8.2   https://tukaani.org/xz/
# zlib       1.3.1   https://github.com/madler/zlib/releases/
# zstd       1.5.7   https://github.com/facebook/zstd/releases/
# glibc      2.42    https://mirrors.ustc.edu.cn/gnu/glibc/
build_packages 5.4 /home/lixq/toolchains/systemtap binutils bzip2 curl elfutils gcc ncurses patchelf readline xz zlib zstd systemtap glibc

# eclipse  2025-12   https://www.eclipse.org/downloads/packages/
#                    https://mirrors.aliyun.com/eclipse/technology/epp/downloads/release/
# golang    1.25.6   https://go.dev/dl/go1.25.6.linux-amd64.tar.gz
# jdk       25.0.1   https://www.oracle.com/java/technologies/downloads/
# miniforge 25.11.0  https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/
# websocat  1.14.1   https://github.com/vi/websocat/releases

tae=$(date +%s)
date "+%Y-%m-%d %H:%M:%S end   use $((tae - tab)) seconds" | tee -a /tmp/build_all.log
