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

# cmake  4.4.0  https://cmake.org/download/
build_packages 4.4.0 /home/lixq/toolchains/cmake cmake

# lcov  2.5  https://github.com/linux-test-project/lcov/releases/
build_packages 2.5 /home/lixq/toolchains/lcov lcov

# Shellcheck  0.11.0  https://github.com/koalaman/shellcheck/releases
build_packages 0.11.0 /home/lixq/toolchains/shellcheck shellcheck

# gcc     16.1.0  https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/
# ./contrib/download_prerequisites  https://gcc.gnu.org/pub/gcc/infrastructure/
# binutils  2.46  https://mirrors.tuna.tsinghua.edu.cn/gnu/binutils/
gccver=16.1.0
build_packages $gccver /opt/gcc gcc binutils
build_packages $gccver /home/lixq/toolchains/gcc gcc binutils

# gdb       17.2  https://mirrors.tuna.tsinghua.edu.cn/gnu/gdb/
# expat    2.8.1  https://github.com/libexpat/libexpat/releases/
# gmp      6.3.0  https://mirrors.tuna.tsinghua.edu.cn/gnu/gmp/
# mpfr     4.2.2  https://mirrors.tuna.tsinghua.edu.cn/gnu/mpfr/
# ncurses    6.6  https://invisible-island.net/ncurses/
# xz       5.8.3  https://tukaani.org/xz/
# zstd     1.5.7  https://github.com/facebook/zstd/releases/
# Python  3.14.3  https://www.python.org/ftp/python/
build_packages 17.2 /home/lixq/toolchains/gdb expat gmp mpfr ncurses xz zstd Python gdb
build_packages 17.2 /home/watch/toolchains/gdb expat gmp mpfr ncurses xz zstd Python gdb

# gdb              16.3   https://mirrors.tuna.tsinghua.edu.cn/gnu/gdb/
# core_analyzer  2.24.0   https://github.com/yanqi27/core_analyzer/releases
# expat           2.7.5   https://github.com/libexpat/libexpat/releases/
# gmp             6.3.0   https://mirrors.tuna.tsinghua.edu.cn/gnu/gmp/
# mpfr            4.2.3   https://mirrors.tuna.tsinghua.edu.cn/gnu/mpfr/
# ncurses           6.6   https://invisible-island.net/ncurses/
# xz              5.8.2   https://tukaani.org/xz/
# zstd            1.5.7   https://github.com/facebook/zstd/releases/
# Python         3.14.3   https://www.python.org/ftp/python/
build_packages 16.3 /home/lixq/toolchains/gdb16 expat gmp mpfr ncurses xz zstd Python gdb16

# bashdb  4.4-1.0.1  https://sourceforge.net/projects/bashdb/files/bashdb/
build_packages 4.4-1.0.1 /home/lixq/toolchains/bashdb bashdb

# bat  0.26.1  https://github.com/sharkdp/bat/releases/
build_packages 0.26.1 /home/lixq/toolchains/bat bat

# make  4.4.1  https://mirrors.tuna.tsinghua.edu.cn/gnu/make/
build_packages 4.4.1 /home/lixq/toolchains/make make

# glibc            2.43     https://mirrors.ustc.edu.cn/gnu/glibc/
# kernel           6.6.121  https://www.kernel.org/
# pcre2            10.47    https://github.com/PCRE2Project/pcre2/releases/
# audit-userspace  4.1.2    https://github.com/linux-audit/audit-userspace/releases/
# libcap           2.77     https://git.kernel.org/pub/scm/libs/libcap/libcap.git/
build_packages 2.43 /home/lixq/toolchains/glibc pcre2 audit-userspace libcap glibc
build_packages 2.43 /opt/glibc pcre2 audit-userspace libcap glibc

# curl          8.21.0  https://github.com/curl/curl/releases/
# brotli        1.2.0   https://github.com/google/brotli/releases/
# c-ares        1.34.6  https://github.com/c-ares/c-ares/releases/
# gsasl         2.2.2   https://mirrors.tuna.tsinghua.edu.cn/gnu/gsasl/
# keyutils      1.6.3   https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/
# krb5          1.22.2  https://web.mit.edu/kerberos/dist/
# libidn2       2.3.8   https://mirrors.tuna.tsinghua.edu.cn/gnu/libidn/
# libpsl        0.21.5  https://github.com/rockdaboot/libpsl/releases/
# libunistring  1.4.2   https://mirrors.tuna.tsinghua.edu.cn/gnu/libunistring/
# libxml2       2.15.3  https://github.com/GNOME/libxml2/tags
# zlib          1.3.2   https://github.com/madler/zlib/releases/
# zstd          1.5.7   https://github.com/facebook/zstd/releases/
# openssl       4.0.1   https://github.com/openssl/openssl/releases/
# nghttp3       1.16.0  https://github.com/ngtcp2/nghttp3/releases/
# ngtcp2        1.23.0  https://github.com/ngtcp2/ngtcp2/releases/
# nghttp2       1.69.0  https://github.com/nghttp2/nghttp2/releases/
# libssh2       1.11.1  https://libssh2.org/
# openldap      2.6.13  https://www.openldap.org/software/download/
build_packages 8.21.0 /home/lixq/toolchains/curl brotli c-ares gsasl keyutils krb5 libidn2 libpsl libunistring libxml2 zlib zstd openssl nghttp3 ngtcp2 nghttp2 libssh2 openldap curl

# llvm     22.1.8        https://mirrors.tuna.tsinghua.edu.cn/github-release/llvm/llvm-project/
# bison    3.8.2         https://mirrors.tuna.tsinghua.edu.cn/gnu/bison/
# libxml2  2.15.3        https://github.com/GNOME/libxml2/tags
# lua      5.5.0         https://www.lua.org/ftp/
# ncurses  6.6           https://invisible-island.net/ncurses/
# libedit  20260512-3.1  https://thrysoee.dk/editline/
# swig     4.4.1         https://github.com/swig/swig/tags/
# xz       5.8.3         https://tukaani.org/xz/
# zlib     1.3.2         https://github.com/madler/zlib/releases/
# zstd     1.5.7         https://github.com/facebook/zstd/releases/
# openssl  4.0.1         https://github.com/openssl/openssl/releases/
# Python   3.14.6        https://www.python.org/ftp/python/
build_packages 22.1.8 /home/lixq/toolchains/llvm bison libxml2 lua ncurses libedit swig xz zlib zstd openssl Python llvm
build_packages 22.1.8 /home/watch/toolchains/lldb bison libxml2 lua ncurses libedit swig xz zlib zstd openssl Python llvm

# zsh  5.9  https://www.zsh.org/
build_packages 5.9 /home/lixq/toolchains/zsh zsh

# boost  1.91.0  https://www.boost.org/releases/latest/
build_packages 1.91.0 /home/lixq/toolchains/boost boost

# tcpflow  1.6.1  https://github.com/simsong/tcpflow/releases/
build_packages 1.6.1 /home/lixq/toolchains/tcpflow tcpflow

# git      2.55.0  https://github.com/git/git/tags/
# brotli   1.2.0   https://github.com/google/brotli/releases/
# expat    2.8.2   https://github.com/libexpat/libexpat/releases/
# libpsl   0.22.0  https://github.com/rockdaboot/libpsl/releases/
# zlib     1.3.2   https://github.com/madler/zlib/releases/
# zstd     1.5.7   https://github.com/facebook/zstd/releases/
# openssl  4.0.1   https://github.com/openssl/openssl/releases/
# curl     8.21.0  https://github.com/curl/curl/releases/
# glibc    2.43    https://mirrors.ustc.edu.cn/gnu/glibc/
build_packages 2.55.0 /home/lixq/toolchains/git brotli expat libpsl zlib zstd openssl curl glibc git

# node   26.5.0  https://nodejs.org/dist/
# glibc  2.43    https://mirrors.tuna.tsinghua.edu.cn/gnu/glibc/
build_packages 26.5.0 /opt/node glibc node

# bpftrace  0.26.1  https://github.com/bpftrace/bpftrace/releases/
build_packages 0.26.1 /home/lixq/toolchains/bpftrace bpftrace
build_packages 0.26.1 /home/watch/toolchains/bpftrace bpftrace

# bpfsnoop  0.5.5  https://github.com/bpfsnoop/bpfsnoop/tags
build_packages  0.5.5  /home/lixq/toolchains/bpfsnoop bpfsnoop

# bcc       0.37.0         https://github.com/iovisor/bcc/releases/
# bison     3.8.2          https://mirrors.tuna.tsinghua.edu.cn/gnu/bison/
# brotli    1.2.0          https://github.com/google/brotli/releases/
# bzip2     1.0.8          https://sourceware.org/pub/bzip2/
# flex      2.6.4          https://github.com/westes/flex/releases/
# icu4c     78.3           https://github.com/unicode-org/icu/
# json-c    0.19-20260627  https://github.com/json-c/json-c/tags
# LuaJIT    2.1.ROLLING    https://github.com/LuaJIT/LuaJIT/tags
# netperf   2.7.0          https://github.com/HewlettPackard/netperf/tags
# libbpf    1.7.0          https://github.com/libbpf/libbpf/releases
# libedit   20260512-3.1   https://thrysoee.dk/editline/
# libffi    3.6.0          https://github.com/libffi/libffi/releases/
# libpsl    0.22.0         https://github.com/rockdaboot/libpsl/releases/
# libxml2   2.15.3         https://github.com/GNOME/libxml2/tags
# ncurses   6.6            https://invisible-island.net/ncurses/
# xz        5.8.3          https://tukaani.org/xz/
# zlib      1.3.2          https://github.com/madler/zlib/releases/
# zstd      1.5.7          https://github.com/facebook/zstd/releases/
# openssl   4.0.1          https://github.com/openssl/openssl/releases/
# curl      8.21.0         https://github.com/curl/curl/releases/
# elfutils  0.195          https://sourceware.org/elfutils/ftp/
# glibc     2.43           https://mirrors.ustc.edu.cn/gnu/glibc/
# Python    3.14.6         https://www.python.org/ftp/python/
build_packages 0.37.0 /home/lixq/toolchains/bcc bison brotli bzip2 flex icu4c json-c LuaJIT netperf libbpf libedit libffi libpsl libxml2 ncurses xz zlib zstd openssl curl elfutils glibc Python bcc
build_packages 0.37.0 /home/watch/toolchains/bcc bison brotli bzip2 flex icu4c json-c libbpf libedit libffi libpsl libxml2 LuaJIT ncurses netperf openssl xz zlib zstd curl elfutils glibc Python bcc

# systemtap  5.5     https://sourceware.org/systemtap/ftp/releases/
# binutils   2.46    https://mirrors.tuna.tsinghua.edu.cn/gnu/binutils/
# bzip2      1.0.8   https://sourceware.org/pub/bzip2/
# elfutils   0.195   https://sourceware.org/elfutils/ftp/
# gcc        16.1.0  https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/
# ncurses    6.6     https://invisible-island.net/ncurses/
# openssl    4.0.0   https://github.com/openssl/openssl/releases/
# patchelf   0.15.5  https://github.com/NixOS/patchelf/releases/
# readline   8.3     https://mirrors.tuna.tsinghua.edu.cn/gnu/readline/
# xz         5.8.3   https://tukaani.org/xz/
# zlib       1.3.2   https://github.com/madler/zlib/releases/
# zstd       1.5.7   https://github.com/facebook/zstd/releases/
# curl       8.20.0  https://github.com/curl/curl/releases/
# glibc      2.43    https://mirrors.ustc.edu.cn/gnu/glibc/
build_packages 5.5 /home/lixq/toolchains/systemtap binutils bzip2 openssl curl elfutils gcc ncurses patchelf readline xz zlib zstd systemtap glibc
build_packages 5.5 /home/watch/toolchains/systemtap binutils bzip2 openssl curl elfutils gcc ncurses patchelf readline xz zlib zstd systemtap glibc

# wrk  4.2.0  https://github.com/wg/wrk/tags
build_packages 4.2.0 /home/lixq/toolchains/wrk wrk

# nasm  3.02  https://www.nasm.us/pub/nasm/releasebuilds/
build_packages 3.02 /home/lixq/toolchains/nasm nasm

# FFmpeg     8.1.2   https://github.com/FFmpeg/FFmpeg/tags
# bzip2      1.0.8   https://sourceware.org/pub/bzip2/
# libXau     1.0.12  https://xorg.freedesktop.org/archive/individual/lib/
# xcb-proto  1.17.0  https://xorg.freedesktop.org/archive/individual/proto/
# libxcb     1.17.0  https://xorg.freedesktop.org/archive/individual/lib/
# xz         5.8.3   https://tukaani.org/xz/
# zlib       1.3.2   https://github.com/madler/zlib/releases/
build_packages 8.1.2 /home/lixq/toolchains/FFmpeg bzip2 libXau xcb-proto libxcb xz zlib FFmpeg

# cppcheck  2.21.0  https://cppcheck.sourceforge.io/
build_packages 2.21.0 /home/lixq/toolchains/cppcheck cppcheck

# Bear         4.1.5     https://github.com/rizsotto/Bear/releases/
build_packages 4.1.5 /home/lixq/toolchains/Bear Bear

# ninja          1.13.2      https://github.com/ninja-build/ninja/releases/
# patchelf       0.19.1      https://github.com/NixOS/patchelf/releases/
# pandoc         3.10        https://github.com/jgm/pandoc/releases/
# eclipse        2026-06     https://www.eclipse.org/downloads/packages/
#                            https://mirrors.aliyun.com/eclipse/technology/epp/downloads/release/
#                            markdown json(Wild Web Developer) bash
# PyDev          13.1.0      https://github.com/fabioz/Pydev/releases
# jdk            26.0.1      https://www.oracle.com/java/technologies/downloads/
# miniforge      26.3.2-3    https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/
# websocat       1.14.1      https://github.com/vi/websocat/releases/
# rr-debuger     5.9.0       https://github.com/rr-debugger/rr/releases/
# cygwin         3.6.9       https://cygwin.com/
# golang         1.26.5      https://golang.google.cn/dl/
# rust           1.97.1      https://rust-lang.org/
# rime           0.17.4      https://rime.im/
# rime-frost     1.0.4       https://github.com/gaboolic/rime-frost/releases
# tabby          1.0.234     https://github.com/Eugeny/tabby/releases
# onnxruntime    1.27.0      https://pypi.org/project/onnxruntime/
# bazel          9.2.0       https://github.com/bazelbuild/bazel/releases/
# nvim           0.12.4      https://github.com/neovim/neovim/releases/
# rg             15.2.0      https://github.com/BurntSushi/ripgrep/releases/
# btop           1.4.7       https://github.com/aristocratos/btop/releases/
# fd             10.4.2      https://github.com/sharkdp/fd/releases/
# fzf            0.74.1      https://github.com/junegunn/fzf/releases/
# lazygit        0.63.1      https://github.com/jesseduffield/lazygit/releases/
# zoxide         0.10.0      https://github.com/ajeetdsouza/zoxide/releases/
# lazyVim        16.0.0      https://github.com/LazyVim/LazyVim/releases/
# windterm       2.7.0       https://github.com/kingToolbox/WindTerm/releases/
# LuaLS          3.18.2      https://github.com/LuaLS/lua-language-server/releases/
# golangci-lint  2.12.2      https://github.com/golangci/golangci-lint/releases/
# codelldb       1.12.2      https://github.com/vadimcn/codelldb/releases/
# Nerd Fonts     3.4.0       https://github.com/ryanoasis/nerd-fonts/releases/
# tree-sitter    0.26.11     https://github.com/tree-sitter/tree-sitter/releases/
# marksman       2026-02-08  https://github.com/artempyanykh/marksman/releases/

tae=$(date +%s)
date "+%Y-%m-%d %H:%M:%S end   use $((tae - tab)) seconds" | tee -a /tmp/build_all.log
