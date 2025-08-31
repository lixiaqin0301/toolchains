#!/bin/bash

name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=2.51.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz

rm -rf /home/lixq/src/git_success

[[ -n $DESTDIR ]] || exit 1
[[ -f $srcpath ]] || exit 1
[[ -f /home/lixq/src/docbook.sourceforge.net.tar.gz ]] || exit 1

export PATH="/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib/pkgconfig"
export CFLAGS="-I/home/lixq/src/$name-$ver -I$DESTDIR/usr/include --sysroot=$DESTDIR"
export CXXFLAGS="-I/home/lixq/src/$name-$ver -I$DESTDIR/usr/include --sysroot=$DESTDIR"
export CPPFLAGS="-I/home/lixq/src/$name-$ver -I$DESTDIR/usr/include --sysroot=$DESTDIR"
export LDFLAGS="-L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -L$DESTDIR/lib -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib -static-libgcc -static-libstdc++ -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/lib:$DESTDIR/usr/lib"

function recover() {
    [[ -f /etc/hosts.bak ]] && mv /etc/hosts.bak /etc/hosts
    killall nginx
    killall nginx
    test -f /home/lixq/src/git_success
}
trap recover EXIT
cp /etc/hosts /etc/hosts.bak
rm -rf /home/lixq/src/build-git-server
mkdir -p /home/lixq/src/build-git-server/conf /home/lixq/src/build-git-server/logs
cd /home/lixq/src || exit 1
rm -rf docbook.sourceforge.net
tar -xf docbook.sourceforge.net.tar.gz || exit 1
cd /home/lixq/src/build-git-server/conf || exit 1
{
    echo "user root;"
    echo "events { }"
    echo "http {"
    host=docbook.sourceforge.net
    echo -e "CN\nFuJian\nXiaMen\nWangSu\nCache\n$host\nlixq@wangsu.com\n\n" | /usr/bin/openssl req -newkey rsa:2048 -nodes -keyout "${host}.key" -out "${host}.csr"
    /usr/bin/openssl x509 -signkey "${host}.key" -in "${host}.csr" -req -days 3650 -out "${host}.crt"
    echo "    server {"
    echo "        root /home/lixq/src/docbook.sourceforge.net;"
    echo "        server_name ${host};"
    echo "        listen 80;"
    echo "        listen 443 ssl;"
    echo "        autoindex on;"
    echo "        ssl_certificate     /home/lixq/src/build-git-server/conf/${host}.crt;"
    echo "        ssl_certificate_key /home/lixq/src/build-git-server/conf/${host}.key;"
    echo "    }"
    sed -i "/ ${host}\$/d" /etc/hosts
    sed -i "\$a 127.0.0.1 ${host}" /etc/hosts
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
rm -rf "$name-$ver"
tar -xf "$srcpath" || exit 1
cd "$name-$ver" || exit 1
make configure || exit 1
./configure "--prefix=$DESTDIR/usr" || exit 1
make -s "-j$(nproc)" all doc || exit 1
make -s "-j$(nproc)" install install-doc install-html || exit 1
