#!/bin/bash

ver=0.9.0-dev-1319

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/home/lixq/toolchains/cmake/bin
. /opt/rh/devtoolset-11/enable

if [[ ! -f /home/lixq/src/neovim-nightly-0.9.0-dev-1319-10baf8971.tar.gz ]]; then
    echo "https://github.com/neovim/neovim/archive/refs/tags/nightly.tar.gz -O neovim-nightly-0.9.0-dev-1319-10baf8971.tar.gz"
    exit 1
fi

cd /home/lixq/src || exit 1
rm -rf neovim-nightly
tar -xf neovim-nightly-0.9.0-dev-1319-10baf8971.tar.gz
cd neovim-nightly || exit 1

all_get=1
for url in $(grep 'set.*URL http' /home/lixq/src/neovim-nightly/cmake.deps/CMakeLists.txt | awk -F '[ )]' '{print $2}') \
    https://luarocks.org/manifest-5.1.zip                                                                               \
    https://luarocks.org/mpack-1.0.10-0.src.rock                                                                        \
    https://luarocks.org/lpeg-1.0.2-1.src.rock                                                                          \
    https://luarocks.org/busted-2.1.1-1.src.rock                                                                        \
    https://luarocks.org/lua_cliargs-3.0-2.src.rock                                                                     \
    https://luarocks.org/luafilesystem-1.8.0-1.src.rock                                                                 \
    https://luarocks.org/luasystem-0.2.1-0.src.rock                                                                     \
    https://luarocks.org/dkjson-2.6-1.src.rock                                                                          \
    https://luarocks.org/say-1.4.1-3.src.rock                                                                           \
    https://luarocks.org/luassert-1.9.0-1.src.rock                                                                      \
    https://luarocks.org/lua-term-0.7-1.rockspec                                                                        \
    https://github.com/hoelzro/lua-term/archive/0.07.tar.gz                                                             \
    https://luarocks.org/penlight-1.13.1-1.src.rock                                                                     \
    https://luarocks.org/mediator_lua-1.1.2-0.rockspec                                                                  \
    https://github.com/Olivine-Labs/mediator_lua/archive/v1.1.2-0.tar.gz                                                \
    https://luarocks.org/luacheck-1.1.0-1.src.rock                                                                      \
    https://luarocks.org/argparse-0.7.1-1.src.rock                                                                      \
    ; do
    filepath="/home/lixq/src/nginx_neovim/${url#https://*/}"
    if [[ ! -f "$filepath" ]]; then
        echo "mkdir -p $(dirname "$filepath"); wget ${url} -O $filepath"
        all_get=0
    fi
done
if [[ "$all_get" == 0 ]]; then
    exit 1
fi

:> /tmp/nginx_access.log

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

for host in ftp.gnu.org github.com launchpad.net www.lua.org luarocks.org; do
    sed -i -e "/$host/d" /etc/hosts
    sed -i -e "\$a 127.0.0.1 $host" /etc/hosts
done

make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/home/lixq/toolchains/neovim-${ver} || exit 1
rm -rf /home/lixq/toolchains/neovim-${ver}
make install || exit 1
if [[ -d /home/lixq/toolchains/neovim-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm -f neovim
    ln -s neovim-${ver} neovim
fi
