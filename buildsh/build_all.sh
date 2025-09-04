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

# cmake  4.1.0  https://cmake.org/download/
build_packages 4.1.0 /home/lixq/toolchains/cmake cmake

# Shellcheck  0.11.0  https://github.com/koalaman/shellcheck/releases
build_packages 0.11.0 /home/lixq/toolchains/shellcheck shellcheck

# gcc     15.2.0  https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/
# ./contrib/download_prerequisites  https://gcc.gnu.org/pub/gcc/infrastructure/
# binutils  2.45  https://mirrors.tuna.tsinghua.edu.cn/gnu/binutils/
gccver=15.2.0
build_packages $gccver /opt/gcc gcc binutils
build_packages $gccver /home/lixq/toolchains/gcc gcc binutils

# gdb  16.3  https://mirrors.tuna.tsinghua.edu.cn/gnu/gdb/
build_packages 16.3 /home/lixq/toolchains/gdb gdb

# Bear  3.1.6  https://github.com/rizsotto/Bear/
build_packages 3.1.6 /home/lixq/toolchains/Bear Bear

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
build_packages 8.15.0 /home/lixq/toolchains/curl keyutils libidn2 libunistring zlib zstd openssl nghttp3 ngtcp2 nghttp2 libssh2 brotli krb5 openldap libpsl gsasl curl

# bison    3.8.2         https://mirrors.tuna.tsinghua.edu.cn/gnu/bison/
# swig     4.3.1         https://github.com/swig/swig/tags
# libedit  20250104-3.1  https://thrysoee.dk/editline/
# ncurses  6.3           https://invisible-island.net/ncurses/
# xz       5.8.1         https://tukaani.org/xz/
# libxml2  2.14.5        https://gitlab.gnome.org/GNOME/libxml2/-/releases
# Python   3.13.7        https://www.python.org/ftp/python/
# lua      5.4.8         https://www.lua.org/ftp/
# llvm     21.1.0        https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/
build_packages 21.1.0 /home/lixq/toolchains/llvm bison swig ncurses libedit xz zlib libxml2 openssl Python lua llvm

# zsh  5.9  https://www.zsh.org/
build_packages 5.9 /home/lixq/toolchains/zsh zsh

# boost  1.89.0  https://www.boost.org/releases/latest/
build_packages 1.89.0 /home/lixq/toolchains/boost boost

# tcpflow  1.6.1  https://github.com/simsong/tcpflow/releases/
build_packages 1.6.1 /home/lixq/toolchains/tcpflow tcpflow

# expat 2.7.1  https://github.com/libexpat/libexpat/releases/
# git  2.51.0  https://github.com/git/git/tags
build_packages 2.51.0 /home/lixq/toolchains/git expat libpsl zlib openssl curl glibc git

# node  24.7.0  https://nodejs.org/dist
build_packages 24.7.0 /home/lixq/toolchains/node glibc node

# bpftrace  0.23.5 https://github.com/bpftrace/bpftrace/releases
build_packages  0.23.5  /home/lixq/toolchains/bpftrace bpftrace

# bzip2     1.0.8          https://sourceware.org/pub/bzip2/
# elfutils  0.193          https://sourceware.org/elfutils/ftp/
# flex      2.6.4          https://github.com/westes/flex/releases/
# icu4c     77.1           https://github.com/unicode-org/icu/
# json-c    0.18-20240915  https://github.com/json-c/json-c/tags
# LuaJIT    2.1.ROLLING    https://github.com/LuaJIT/LuaJIT/tags
# netperf   2.7.0          https://github.com/HewlettPackard/netperf/tags
# libbpf    1.6.2          https://github.com/libbpf/libbpf/releases
# bcc       0.35.0         https://github.com/iovisor/bcc/releases/
build_packages 0.35.0 /home/lixq/toolchains/bcc bison brotli bzip2 flex icu4c json-c libbpf libedit libffi libpsl libxml2 LuaJIT ncurses netperf openssl xz zlib zstd curl elfutils glibc Python bcc

# systemtap  5.3  https://sourceware.org/systemtap/ftp/releases/
# readline   8.3  https://mirrors.tuna.tsinghua.edu.cn/gnu/readline/
build_packages 5.3 /home/lixq/toolchains/systemtap binutils bzip2 elfutils gcc_10.4.0 ncurses patchelf readline xz zlib systemtap glibc
# DESTDIR=/home/lixq/toolchains/systemtap
# patchbins=("$DESTDIR/usr/bin/stap" "$DESTDIR/usr/bin/stapbpf" "$DESTDIR/usr/bin/stap-merge" "$DESTDIR/usr/bin/staprun" "$DESTDIR/usr/bin/stapsh" "$DESTDIR/usr/libexec/systemtap/stapio")
# [[ -d $DESTDIR/lib64 ]] || mkdir -p "$DESTDIR/lib64"
# for f in "$DESTDIR/usr/bin/"* "$DESTDIR/usr/libexec/systemtap/stap"*; do
#     ldd "$f" | grep ' => /[^h]' | awk '{print $3}' | while read -r lib; do
#         if [[ ! -f $DESTDIR$lib ]]; then
#             [[ -d $(dirname "$DESTDIR$lib") ]] || mkdir -p "$(dirname "$DESTDIR$lib")"
#             if [[ -f /home/lixq/toolchains/glibc$lib ]]; then
#                 cp "/home/lixq/toolchains/glibc$lib" "$DESTDIR$lib"
#             else
#                 cp "$lib" "$DESTDIR$lib"
#             fi
#         fi
#         patchelf --set-rpath "$LD_RUN_PATH" "$DESTDIR$lib"
#     done
#     patchelf --set-interpreter "$DESTDIR/lib64/ld-linux-x86-64.so.2" "$f"
# done
# cp /home/lixq/toolchains/glibc/lib64/ld-linux-x86-64.so.2 "$DESTDIR/lib64"
# for f in "$DESTDIR"/usr/*bin/* "$DESTDIR"/*bin/* "$DESTDIR"/usr/lib*/* "$DESTDIR"/lib*/* "$DESTDIR/usr/libexec/"*/*; do
#     [[ -L $f ]] && continue
#     [[ -d $f ]] && continue
#     ldd "$f" 2>/dev/null | grep -q ' => ' || continue
#     readelf -d "$f" | grep -q "$DESTDIR" || continue
#     echo "$f"
# done

# while IFS= read -r f; do
#     [[ -f "$DESTDIR$f" ]] || cp "$f" "$DESTDIR$f"
# done < <(ldd "${patchbins[@]}" 2>&1 | grep ' => /[^h]' | awk '{print $3}' | sort -u)

# while IFS= read -r f; do
#     patchelf --set-rpath "$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib" "$f"
# done < <(ldd "${patchbins[@]}" 2>&1 | grep ' => /h' | awk '{print $3}' | sort -u)
    #patchelf --set-rpath "$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib" "$f"
    #file "$f" | grep 'uses shared libs' || continue
    #patchelf --set-interpreter "$DESTDIR/lib64/ld-linux-x86-64.so.2" "$f"
tae=$(date +%s)
date "+%Y-%m-%d %H:%M:%S end   use $((tae - tab)) seconds" | tee -a /tmp/build_all.log
