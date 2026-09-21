#!/bin/bash
set -euo pipefail

export MANPATH=
export PCP_DIR=
export LD_LIBRARY_PATH=
export PKG_CONFIG_PATH=
export INFOPATH=
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
. /opt/rh/devtoolset-11/enable
export PATH="$HOME/.cargo/bin:/home/lixq/toolchains/bin:$PATH"
export http_proxy=http://repo.haplat.net:60028
export https_proxy=http://repo.haplat.net:60028
export all_proxy=http://repo.haplat.net:60028

cd "$HOME"
rm -rf .rustup
rm -rf .cargo
mkdir .cargo

cat > .cargo/config.toml << EOF
[source.crates-io]
replace-with = "rsproxy"

[source.rsproxy]
registry = "sparse+https://rsproxy.cn/index/"

[http]
proxy = "http://repo.haplat.net:60028"
EOF

export RUSTUP_DIST_SERVER=https://rsproxy.cn
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
/share-rd/cdn_prd_cache/lixq/src/vers/rustup-init -y --no-modify-path --default-host x86_64-unknown-linux-gnu --profile default
rustc --version
cargo --version
