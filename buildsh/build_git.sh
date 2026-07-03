#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=2.55.0
DESTDIR=$1
srcpath=/home/lixq/src/$name-$ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]
[[ -f /home/lixq/src/docbook.sourceforge.net.tar.gz ]]

export PATH="$DESTDIR/usr/bin:/root/.cargo/bin:/home/lixq/toolchains/gcc/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PKG_CONFIG_PATH="$DESTDIR/usr/lib64/pkgconfig:$DESTDIR/usr/lib/pkgconfig"
export CPPFLAGS="-I/home/lixq/src/$name-$ver --sysroot=$DESTDIR"
export LDFLAGS="-L$DESTDIR/lib64 -L$DESTDIR/usr/lib64 -L$DESTDIR/usr/lib -Wl,-rpath-link,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/usr/lib --sysroot=$DESTDIR -Wl,-rpath,$DESTDIR/lib64:$DESTDIR/usr/lib64:$DESTDIR/usr/lib -Wl,--dynamic-linker=$DESTDIR/lib64/ld-linux-x86-64.so.2"

rm -rf /home/lixq/src/git_success
GCC_INCLUDE_FIXED=""
for d in /home/lixq/toolchains/gcc/usr/lib/gcc/x86_64-pc-linux-gnu/*/include-fixed/; do
    [[ -d "$d" ]] || continue
    GCC_INCLUDE_FIXED=$(realpath "$d")
    break
done
function recover() {
    [[ -d "$GCC_INCLUDE_FIXED.bak" ]] && mv "$GCC_INCLUDE_FIXED.bak" "$GCC_INCLUDE_FIXED"
    [[ -f /etc/hosts.bak ]] && mv /etc/hosts.bak /etc/hosts
    killall openresty || true
    killall openresty || true
    test -f /home/lixq/src/git_success
}
trap recover EXIT

cp /etc/hosts /etc/hosts.bak
rm -rf /home/lixq/src/build-git-server
mkdir -p /home/lixq/src/build-git-server/conf /home/lixq/src/build-git-server/logs
cd /home/lixq/src
rm -rf docbook.sourceforge.net
tar -xf docbook.sourceforge.net.tar.gz
cd /home/lixq/src/build-git-server/conf
host=docbook.sourceforge.net
echo -e "CN\nFuJian\nXiaMen\nWangSu\nCache\n$host\nlixq@wangsu.com\n\n" | /usr/bin/openssl req -newkey rsa:2048 -nodes -keyout "${host}.key" -out "${host}.csr"
/usr/bin/openssl x509 -signkey "${host}.key" -in "${host}.csr" -req -days 3650 -out "${host}.crt"
cat > nginx.conf << EOF
user root;
events { }
http {
    server {
        root /home/lixq/src/docbook.sourceforge.net;
        server_name ${host};
        listen 80;
        listen 443 ssl;
        autoindex on;
        ssl_certificate     /home/lixq/src/build-git-server/conf/${host}.crt;
        ssl_certificate_key /home/lixq/src/build-git-server/conf/${host}.key;
    }
}
EOF
sed -i "/ ${host}\$/d" /etc/hosts
sed -i "\$a 127.0.0.1 ${host}" /etc/hosts
cp /etc/hosts /home/lixq/src/build-git-server/
while killall openresty; do
    sleep 1
done
openresty -p /home/lixq/src/build-git-server/
sleep 1
wget http://docbook.sourceforge.net/release/xsl/current/html/docbook.xsl -O /tmp/docbook.xsl
cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "$name-$ver"
mv "$GCC_INCLUDE_FIXED" "$GCC_INCLUDE_FIXED.bak"
make configure
./configure "--prefix=$DESTDIR/usr"
make -s "-j$(nproc)" all doc
make -s "-j$(nproc)" install install-doc install-html
touch /home/lixq/src/git_success
