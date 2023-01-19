#!/bin/bash

ver=0.9.0-dev-737

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/home/lixq/toolchains/cmake/bin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/src/neovim-nightly.tar.gz ]]; then
    echo "wget https://github.com/neovim/neovim/archive/refs/tags/nightly.tar.gz -O /home/lixq/src/neovim-nightly.tar.gz"
    exit 1
fi

for p in                                                                              \
    neovim/unibilium/archive/92d929f.tar.gz                                           \
    code/libtermkey/libtermkey-0.22.tar.gz                                            \
    code/libvterm/libvterm-0.3.1.tar.gz                                               \
    libuv/libuv/archive/f610339f74f7f0fcd183533d2c965ce1468b44c6.tar.gz               \
    msgpack/msgpack-c/releases/download/c-4.0.0/msgpack-c-4.0.0.tar.gz                \
    LuaJIT/LuaJIT/archive/d0e88930ddde28ff662503f9f20facf34f7265aa.tar.gz             \
    luarocks/luarocks/archive/v3.8.0.tar.gz                                           \
    keplerproject/lua-compat-5.3/archive/v0.9.tar.gz                                  \
    luvit/luv/archive/80c8c00baebe3e994d1616d4b54097c2d6e14834.tar.gz                 \
    tree-sitter/tree-sitter-c/archive/v0.20.2.tar.gz                                  \
    MunifTanjim/tree-sitter-lua/archive/v0.0.14.tar.gz                                \
    vigoux/tree-sitter-viml/archive/55ff1b080c09edeced9b748cf4c16d0b49d17fb9.tar.gz   \
    neovim/tree-sitter-vimdoc/archive/ce20f13c3f12506185754888feaae3f2ad54c287.tar.gz \
    tree-sitter/tree-sitter/archive/eb970a83a107cbaba52e31588355c0b09b3a308a.tar.gz   \
    Olivine-Labs/busted/archive/v2.0.0.tar.gz                                         \
    hoelzro/lua-term/archive/0.07.tar.gz                                              \
    Olivine-Labs/mediator_lua/archive/v1.1.2-0.tar.gz                                 \
    ; do
    if [[ ! -f /home/lixq/src/nginx_neovim/${p} ]]; then
        echo "wget https://github.com/${p} -O /home/lixq/src/nginx_neovim/${p}"
        exit 1
    fi
done

for f in                          \
    busted-2.0.0-1.rockspec       \
    lpeg-1.0.2-1.src.rock         \
    manifest-5.1.zip              \
    mpack-1.0.8-0.rockspec        \
    penlight-1.5.4-1.src.rock     \
    lua_cliargs-3.0-2.src.rock    \
    luasystem-0.2.1-0.src.rock    \
    dkjson-2.6-1.src.rock         \
    say-1.4.1-3.src.rock          \
    luassert-1.9.0-1.src.rock     \
    lua-term-0.7-1.rockspec       \
    mediator_lua-1.1.2-0.rockspec \
    luacheck-0.23.0-1.src.rock    \
    argparse-0.7.1-1.src.rock     \
    nvim-client-0.2.4-1.src.rock  \
    luv-1.44.2-1.src.rock         \
    coxpcall-1.17.0-1.src.rock    \
    ; do
    if [[ ! -f /home/lixq/src/nginx_neovim/${f} ]]; then
        echo "wget https://luarocks.org/${f} -O /home/lixq/src/nginx_neovim/${f}"
        exit 1
    fi
done

while killall nginx; do
    sleep 1
done

if ss -ltpn | grep ':443 '; then
    exit 1
fi

nginx -c /home/lixq/src/nginx_neovim/nginx.conf || exit 1
until ss -ltpn | grep ':443 '; do
    sleep 1
done
:> /tmp/nginx_access.log
sed -i -e '/luarocks.org/d' -e '/github.com/d' '/www.leonerd.org.uk/d' /etc/hosts
sed -i -e '$a 127.0.0.1 luarocks.org' -e '$a 127.0.0.1 github.com' -e '$a 127.0.0.1 www.leonerd.org.uk' /etc/hosts

cd /home/lixq/src || exit 1
rm -rf neovim-nightly
tar -xvf neovim-nightly.tar.gz
cd neovim-nightly || exit 1

make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/home/lixq/toolchains/neovim-${ver} || exit 1
rm -rf /home/lixq/toolchains/neovim-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/neovim-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f neovim
    ln -s neovim-${ver} neovim
fi
