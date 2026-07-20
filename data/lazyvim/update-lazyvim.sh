#!/bin/bash
set -euo pipefail
export PATH="/home/lixq/toolchains/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [[ -d /root/.config/nvim ]]; then
    cd /root/.config/nvim || exit 1
    git checkout -- .
    git clean -ffdx
    cat /home/lixq/toolchains/data/lazyvim/options.lua >> lua/config/options.lua
    sed -i '/import = "lazyvim.plugins"/r /home/lixq/toolchains/data/lazyvim/lazy.lua' lua/config/lazy.lua
    mkdir -p lua/plugins
    rsync -a /home/lixq/toolchains/data/lazyvim/plugins/ lua/plugins/
fi
/home/lixq/toolchains/nvim-linux-x86_64/bin/nvim --headless "+Lazy! sync" +qa
