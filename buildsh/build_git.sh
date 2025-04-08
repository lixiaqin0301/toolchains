#!/bin/bash

ver=2.49.0

if [[ ! -f /home/lixq/35share-rd/src/git-${ver}.tar.gz ]]; then
    echo "wget https://github.com/git/git/archive/refs/tags/v${ver}.tar.gz -O git-${ver}.tar.gz"
    exit 1
fi
if ! wget http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl -O /tmp/docbook.xsl; then
    echo "get git doc"
    echo 1
fi

export PATH=/home/lixq/toolchains/Miniforge3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
. /opt/rh/devtoolset-11/enable
export CPATH="/home/lixq/toolchains/Miniforge3/include:$CPATH"
export PKG_CONFIG_PATH="/home/lixq/toolchains/Miniforge3/lib/pkgconfig:$PKG_CONFIG_PATH"
export LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/Miniforge3/lib $LDFLAGS"

#function recover() {
#    [[ -f /etc/hosts.bak ]] && mv /etc/hosts.bak /etc/hosts
#}
#trap recover EXIT
#cp /etc/hosts /etc/hosts.bak
#mkdir -p /home/lixq/toolchains/vscode-server-lib/nginx/etc/
#cd /home/lixq/toolchains/vscode-server-lib/nginx/etc/ || exit 1
#{
#    echo "user root;"
#    echo "events { }"
#    echo "http {"
#    for d in /home/lixq/35share-rd/src/*/; do
#        host=$(basename "$d")
#        echo -e "CN\nFuJian\nXiaMen\nWangSu\nCache\n$host\nlixq@wangsu.com\n\n" | openssl req -newkey rsa:2048 -nodes -keyout "${host}.key" -out "${host}.csr"
#        openssl x509 -signkey "${host}.key" -in "${host}.csr" -req -days 3650 -out "${host}.crt"
#        echo "    server {"
#        echo "        root ${d};"
#        echo "        server_name ${host};"
#        echo "        listen 80;"
#        echo "        listen 443 ssl;"
#        echo "        autoindex on;"
#        echo "        ssl_certificate     /home/lixq/toolchains/vscode-server-lib/nginx/etc/${host}.crt;"
#        echo "        ssl_certificate_key /home/lixq/toolchains/vscode-server-lib/nginx/etc/${host}.key;"
#        echo "    }"
#        sed -i "/ ${host}\$/p" /etc/hosts
#        sed -i "\$a 127.0.0.1 ${host}" /etc/hosts
#    done
#    echo "}"
#} > nginx.conf
#cp /etc/hosts /home/lixq/toolchains/vscode-server-lib/nginx/
#while killall nginx; do
#    sleep 1
#done
#nginx -c /home/lixq/toolchains/vscode-server-lib/nginx/etc/nginx.conf
#sleep 1

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf git-${ver}
tar -xvf /home/lixq/35share-rd/src/git-${ver}.tar.gz
cd git-${ver} || exit 1
sed -i 's;^\(GITLIBS = .*\);\1 /home/lixq/toolchains/Miniforge3/lib/libiconv.a;' Makefile
make configure || exit 1
./configure --prefix=/home/lixq/toolchains/git-${ver} || exit 1
make all doc || exit 1
rm -rf /home/lixq/toolchains/git-${ver}
make install install-doc install-html || exit 1
if [[ -d /home/lixq/toolchains/git-${ver} ]]; then
    cd /home/lixq/toolchains || exit 1
    rm git
    ln -s git-${ver} git
fi
