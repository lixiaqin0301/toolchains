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
    if [[ -f "$DESTDIR/lib64/ld-linux-x86-64.so.2" ]]; then
        while IFS= read -r f; do
            $f --help 2>&1 | grep -q "$f: /lib64/libc.so.6: version .GLIBC_.* not found (required by $f)" || continue
            [[ -f "$f.real" ]] || mv "$f" "$f.real"
            rm -f "$f"
            {
                echo "#!/bin/bash"
                echo "exec '$DESTDIR/lib64/ld-linux-x86-64.so.2' --library-path '$DESTDIR/lib64:$DESTDIR/usr/lib64:/lib64:/lib' --argv0 '$f' '$f.real' \"\$@\""
            } > "$f"
            chmod 755 "$f"
        done < <(find "$DESTDIR" -type f -executable ! -name '*.so' ! -name '*.so.*' ! -name '*.real' -exec file {} + | grep 'uses shared libs' | cut -d: -f1)
    fi
    cd "$(dirname "$DESTDIR")" || exit 1
    tar -czf "$(basename "$DESTDIR")-$ver.tar.gz" "$(basename "$DESTDIR")"
    tse=$(date +%s)
    date "+%Y-%m-%d %H:%M:%S end   $DESTDIR ${pkgs[*]} use $((tse - tsb)) seconds" | tee -a /tmp/build_all.log
}

tab=$(date +%s)
date "+%Y-%m-%d %H:%M:%S begin" | tee /tmp/build_all.log

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

# FFmpeg     9.0.1   https://github.com/FFmpeg/FFmpeg/tags
# bzip2      1.0.8   https://sourceware.org/pub/bzip2/
# libXau     1.0.12  https://xorg.freedesktop.org/archive/individual/lib/
# xcb-proto  1.17.0  https://xorg.freedesktop.org/archive/individual/proto/
# libxcb     1.17.0  https://xorg.freedesktop.org/archive/individual/lib/
# xz         5.8.3   https://tukaani.org/xz/
# zlib       1.3.2   https://github.com/madler/zlib/releases/
build_packages 9.0.1 /home/lixq/toolchains/FFmpeg bzip2 libXau xcb-proto libxcb xz zlib FFmpeg

# cppcheck  2.21.0  https://cppcheck.sourceforge.io/
build_packages 2.21.0 /home/lixq/toolchains/cppcheck cppcheck

# Bear         4.2.2     https://github.com/rizsotto/Bear/releases/
build_packages 4.2.2 /home/lixq/toolchains/Bear Bear

# luarocks  3.13.0  https://github.com/luarocks/luarocks/releases/
build_packages 3.13.0 /home/lixq/toolchains/luarocks luarocks

# cmake                4.4.3           https://cmake.org/download/
# FireFox              155.0.1         https://www.firefox.com/en-US/download/all/desktop-release/win64/zh-CN/
# Chrome               153.0.8010.37   https://www.google.cn/chrome/?standalone=1&platform=win64
# ninja                1.13.2          https://github.com/ninja-build/ninja/releases/
# patchelf             0.19.1          https://github.com/NixOS/patchelf/releases/
# pandoc               3.11            https://github.com/jgm/pandoc/releases/
# eclipse              2026-06         https://www.eclipse.org/downloads/packages/
#                                      https://mirrors.aliyun.com/eclipse/technology/epp/downloads/release/
#                                      markdown json(Wild Web Developer) bash
# PyDev                13.1.0          https://github.com/fabioz/Pydev/releases
# websocat             1.14.1          https://github.com/vi/websocat/releases/
# cygwin               3.6.9           https://cygwin.com/
# golang               1.27.1          https://golang.google.cn/dl/
# rust                 1.98.1          https://rust-lang.org/
# rime                 0.17.4          https://rime.im/
# rime-frost           1.0.4           https://github.com/gaboolic/rime-frost/releases
# tabby                1.0.235         https://github.com/Eugeny/tabby/releases
# nvim                 0.12.5          https://github.com/neovim/neovim/releases/
# rg                   15.2.0          https://github.com/BurntSushi/ripgrep/releases/
# btop                 1.4.7           https://github.com/aristocratos/btop/releases/
# fd                   10.5.0          https://github.com/sharkdp/fd/releases/
# zoxide               0.10.0          https://github.com/ajeetdsouza/zoxide/releases/
# lua-language-server  3.19.1          https://github.com/LuaLS/lua-language-server/releases/
# golangci-lint        2.13.2          https://github.com/golangci/golangci-lint/releases/
# Nerd Fonts           3.5.1           https://github.com/ryanoasis/nerd-fonts/releases/
# tree-sitter          0.27.0          https://github.com/tree-sitter/tree-sitter/releases/
# marksman             2026-02-08      https://github.com/artempyanykh/marksman/releases/

tae=$(date +%s)
date "+%Y-%m-%d %H:%M:%S end   use $((tae - tab)) seconds" | tee -a /tmp/build_all.log
