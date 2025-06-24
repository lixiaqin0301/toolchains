#!/bin/bash

ver=2.50.0

if [[ ! -f /home/lixq/35share-rd/src/git-${ver}.tar.gz ]]; then
    echo "wget https://github.com/git/git/archive/refs/tags/v${ver}.tar.gz -O git-${ver}.tar.gz"
    exit 1
fi

. "$(dirname "${BASH_SOURCE[0]}")/set_build_env.sh" \
    /home/lixq/toolchains/glibc \
    /home/lixq/toolchains/gcc \
    /home/lixq/toolchains/binutils \
    /home/lixq/toolchains/openssl \
    /home/lixq/toolchains/nghttp3 \
    /home/lixq/toolchains/ngtcp2 \
    /home/lixq/toolchains/nghttp2 \
    /home/lixq/toolchains/libpsl \
    /home/lixq/toolchains/libgsasl \
    /home/lixq/toolchains/brotli \
    /home/lixq/toolchains/zlib \
    /home/lixq/toolchains/curl \
    /home/lixq/toolchains/expat \
    /home/lixq/toolchains/Miniforge3

export CFLAGS="-I/home/lixq/src/git-${ver} $CFLAGS"
export CXXFLAGS="-I/home/lixq/src/git-${ver} $CXXFLAGS"

function recover() {
    [[ -f /etc/hosts.bak ]] && mv /etc/hosts.bak /etc/hosts
}
trap recover EXIT
cp /etc/hosts /etc/hosts.bak
rm -rf /home/lixq/src/build-git-server
mkdir -p /home/lixq/src/build-git-server/conf /home/lixq/src/build-git-server/logs
cd /home/lixq/src/build-git-server/conf || exit 1
{
    echo "user root;"
    echo "events { }"
    echo "http {"
    for d in /home/lixq/35share-rd/src/*/; do
        host=$(basename "$d")
        echo -e "CN\nFuJian\nXiaMen\nWangSu\nCache\n$host\nlixq@wangsu.com\n\n" | openssl req -newkey rsa:2048 -nodes -keyout "${host}.key" -out "${host}.csr"
        openssl x509 -signkey "${host}.key" -in "${host}.csr" -req -days 3650 -out "${host}.crt"
        echo "    server {"
        echo "        root ${d};"
        echo "        server_name ${host};"
        echo "        listen 80;"
        echo "        listen 443 ssl;"
        echo "        autoindex on;"
        echo "        ssl_certificate     /home/lixq/src/build-git-server/conf/${host}.crt;"
        echo "        ssl_certificate_key /home/lixq/src/build-git-server/conf/${host}.key;"
        echo "    }"
        sed -i "/ ${host}\$/d" /etc/hosts
        sed -i "\$a 127.0.0.1 ${host}" /etc/hosts
    done
    echo "}"
} > nginx.conf
cp /etc/hosts /home/lixq/src/build-git-server/
while killall nginx; do
    sleep 1
done
nginx -p /home/lixq/src/build-git-server/
sleep 1
if ! wget http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl -O /tmp/docbook.xsl; then
    echo "get git doc"
    echo 1
fi

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
cd /home/lixq/src || exit 1
rm -rf git-${ver}
tar -xf /home/lixq/35share-rd/src/git-${ver}.tar.gz
cd git-${ver} || exit 1
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
