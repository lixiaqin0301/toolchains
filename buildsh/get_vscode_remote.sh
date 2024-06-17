#!/bin/bash

version=1.90.1
commit=611f9bfce64f25108829dd295f54a6894e87339d

[[ -d /share-rd/lixq/vscode ]] || mkdir -p /share-rd/lixq/vscode
if [[ ! -f "/share-rd/lixq/vscode/vscode-server-${version}.linux-x64.tar.gz" ]]; then
    wget "https://update.code.visualstudio.com/commit:${commit}/server-linux-x64/stable" -O "/share-rd/lixq/vscode/vscode-server-${version}.linux-x64.tar.gz" || exit 1
fi
if [[ ! -f "/share-rd/lixq/vscode/vscode-cli-${version}.tar.gz" ]]; then
    wget "https://update.code.visualstudio.com/commit:${commit}/cli-alpine-x64/stable" -O "/share-rd/lixq/vscode/vscode-cli-${version}.tar.gz"
fi

cat > /share-rd/lixq/vscode/v.sh << EOF
rm -rfv /home/lixq/toolchains/vscode-server/code /home/lixq/toolchains/vscode-server/code-*
tar -xvf "/home/lixq/35share-rd/vscode/vscode-cli-${version}.tar.gz" -C /home/lixq/toolchains/vscode-server/
mv /home/lixq/toolchains/vscode-server/code /home/lixq/toolchains/vscode-server/code-${commit}
rm -rfv /home/lixq/toolchains/vscode-server/cli
mkdir -p /home/lixq/toolchains/vscode-server/cli/servers/Stable-${commit}/server
tar -xvf "/home/lixq/35share-rd/vscode/vscode-server-${version}.linux-x64.tar.gz" -C /home/lixq/toolchains/vscode-server/cli/servers/Stable-${commit}/server --strip 1
patchelf --set-interpreter /home/lixq/toolchains/glibc/lib/ld-linux-x86-64.so.2 /home/lixq/toolchains/vscode-server/cli/servers/Stable-${commit}/server/node
EOF
