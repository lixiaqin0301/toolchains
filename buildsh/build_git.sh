#!/bin/bash

ver=2.50.0

if [[ ! -f /home/lixq/35share-rd/src/git-${ver}.tar.gz ]]; then
    echo "wget https://github.com/git/git/archive/refs/tags/v${ver}.tar.gz -O git-${ver}.tar.gz"
    exit 1
fi

export PATH="/home/lixq/toolchains/glibc/usr/sbin:/home/lixq/toolchains/glibc/usr/bin:/home/lixq/toolchains/glibc/sbin:/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/binutils/bin:/home/lixq/toolchains/Miniforge3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export PKG_CONFIG_PATH="/home/lixq/toolchains/Miniforge3/lib/pkgconfig:/home/lixq/toolchains/zlib/lib/pkgconfig"
export CC="/home/lixq/toolchains/gcc/bin/gcc"
export CXX="/home/lixq/toolchains/gcc/bin/g++"
export CCAS="/home/lixq/toolchains/gcc/bin/gcc"
export CPP="/home/lixq/toolchains/gcc/bin/cpp"
export CFLAGS="-I/home/lixq/src/git-${ver} -I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/Miniforge3/include -I/home/lixq/toolchains/zlib/include --sysroot=/home/lixq/toolchains/glibc"
export CXXFLAGS="-I/home/lixq/src/git-${ver} -I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/Miniforge3/include -I/home/lixq/toolchains/zlib/include --sysroot=/home/lixq/toolchains/glibc"
export LDFLAGS="-L/home/lixq/toolchains/glibc/lib64 -L/home/lixq/toolchains/gcc/lib64 -L/home/lixq/toolchains/binutils/lib -L/home/lixq/toolchains/Miniforge3/lib -L/home/lixq/toolchains/zlib/lib --sysroot=/home/lixq/toolchains/glibc -Wl,-rpath=/home/lixq/toolchains/glibc/lib64:/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/binutils/lib:/home/lixq/toolchains/Miniforge3/lib:/home/lixq/toolchains/zlib/lib -Wl,--dynamic-linker=/home/lixq/toolchains/glibc/lib64/ld-linux-x86-64.so.2"

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
