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
