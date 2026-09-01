#!/bin/bash
set -euo pipefail
export PATH="/home/lixq/toolchains/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"

if [[ -d "$HOME/.config/nvim" ]]; then
    cd "$HOME/.config/nvim" || exit 1
    git restore .
    git clean -ffdx
    cat /home/lixq/toolchains/data/lazyvim/options.lua >> lua/config/options.lua
    sed -i '/import = "lazyvim.plugins"/r /home/lixq/toolchains/data/lazyvim/lazy.lua' lua/config/lazy.lua
    mkdir -p lua/plugins
    rsync -a /home/lixq/toolchains/data/lazyvim/plugins/ lua/plugins/
fi
if [[ -f "$HOME"/.local/share/nvim/lazy/nvim-treesitter/lua/nvim-treesitter/parsers.lua ]] && sed -n '/git_config = {/,/},/p' "$HOME"/.local/share/nvim/lazy/nvim-treesitter/lua/nvim-treesitter/parsers.lua | grep -q revision; then
    REV=$(sed -n '/git_config = {/,/},/p' /root/.local/share/nvim/lazy/nvim-treesitter/lua/nvim-treesitter/parsers.lua | awk '$1=="revision"{print $3}' | awk -F "'" '{print $2}')
    [[ -n "$REV" ]]
    if [[ ! -f "$HOME"/.local/share/nvim/site/parser-info/git_config.revision ]] || ! grep -q "$REV" "$HOME"/.local/share/nvim/site/parser-info/git_config.revision; then
        WORK_DIR="$(mktemp -d /tmp/tree-sitter-git-config.XXXXXX)"
        git clone --quiet https://github.com/the-mikedavis/tree-sitter-git-config "$WORK_DIR"
        git -C "$WORK_DIR" checkout --quiet "$REV"
        cd "$WORK_DIR"
        tree-sitter build -o parser.so
        [[ -s "$WORK_DIR"/parser.so ]]
        mkdir -p "$HOME"/.local/share/nvim/site/parser "$HOME"/.local/share/nvim/site/parser-info
        cp "$WORK_DIR"/parser.so "$HOME"/.local/share/nvim/site/parser/git_config.so
        chmod 755 "$HOME"/.local/share/nvim/site/parser/git_config.so
        printf '%s\n' "$REV" > "$HOME"/.local/share/nvim/site/parser-info/git_config.revision
        rm -rf "$WORK_DIR"
    fi
fi
/home/lixq/toolchains/nvim-linux-x86_64/bin/nvim --headless "+Lazy! sync" +qa
