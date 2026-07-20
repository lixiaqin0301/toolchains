#!/bin/bash
set -euo pipefail
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [[ -d /root/.config/nvim ]]; then
    cd /root/.config/nvim || exit 1
    git checkout -- .
    git clean -ffdx
    cat /home/lixq/toolchains/data/lazyvim/options.lua >> lua/config/options.lua
    sed -i '/import = "lazyvim.plugins"/r /home/lixq/toolchains/data/lazyvim/lazy.lua' lua/config/lazy.lua
    mkdir -p lua/plugins
    rsync -a /home/lixq/toolchains/data/lazyvim/plugins/ lua/plugins/
fi
for d in /root/.local/share/nvim/lazy/*/.git; do
    [[ -d "$d/.." ]] || continue
    cd "$d/.."
    git checkout -- .
    git git clean -ffdx
    git pull
done
