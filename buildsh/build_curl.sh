#!/bin/bash

# https://curl.se/docs/http3.html

ver=8.14.1
opensslver=3.5.0
nghttp3ver=1.10.1
ngtcp2ver=1.13.0
nghttp2ver=1.65.0

need_exit=no
if [[ ! -f /home/lixq/35share-rd/src/curl-${ver}.tar.gz ]]; then
    echo "wget https://github.com/curl/curl/releases/download/curl-${ver//./_}/curl-${ver}.tar.gz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/openssl-${opensslver}.tar.gz ]]; then
    echo "wget https://github.com/openssl/openssl/releases/download/openssl-${opensslver}/openssl-${opensslver}.tar.gz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/nghttp3-${nghttp3ver}.tar.gz ]]; then
    echo "wget https://github.com/ngtcp2/nghttp3/releases/download/v${nghttp3ver}/nghttp3-${nghttp3ver}.tar.gz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/ngtcp2-${ngtcp2ver}.tar.gz ]]; then
    echo "wget https://github.com/ngtcp2/ngtcp2/releases/download/v${ngtcp2ver}/ngtcp2-${ngtcp2ver}.tar.gz"
    need_exit=yes
fi
if [[ ! -f /home/lixq/35share-rd/src/nghttp2-${nghttp2ver}.tar.gz ]]; then
    echo "wget https://github.com/nghttp2/nghttp2/releases/download/v${nghttp2ver}/nghttp2-${nghttp2ver}.tar.gz"
    need_exit=yes
fi
if [[ "$need_exit" == yes ]]; then
    exit 1
fi

#export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
#. /opt/rh/devtoolset-11/enable
export PATH="/home/lixq/toolchains/gcc/bin:/home/lixq/toolchains/binutils/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
export PKG_CONFIG_PATH="/home/lixq/toolchains/curl/libs/openssl/lib/pkgconfig:/home/lixq/toolchains/curl/libs/nghttp3/lib/pkgconfig:/home/lixq/toolchains/curl/libs/ngtcp2/lib/pkgconfig:/home/lixq/toolchains/curl/libs/nghttp2/lib/pkgconfig:/home/lixq/toolchains/curl/lib/pkgconfig"
export CC="/home/lixq/toolchains/gcc/bin/gcc"
export CXX="/home/lixq/toolchains/gcc/bin/g++"
export CCAS="/home/lixq/toolchains/gcc/bin/gcc"
export CPP="/home/lixq/toolchains/gcc/bin/cpp"
export CFLAGS="-I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/curl/libs/openssl/include -I/home/lixq/toolchains/curl/libs/nghttp3/include -I/home/lixq/toolchains/curl/libs/ngtcp2/include -I/home/lixq/toolchains/curl/libs/nghttp2/include -I/home/lixq/toolchains/curl/include"
export CXXFLAGS="-I/home/lixq/toolchains/binutils/include -I/home/lixq/toolchains/curl/libs/openssl/include -I/home/lixq/toolchains/curl/libs/nghttp3/include -I/home/lixq/toolchains/curl/libs/ngtcp2/include -I/home/lixq/toolchains/curl/libs/nghttp2/include -I/home/lixq/toolchains/curl/include"
export LDFLAGS="-L/home/lixq/toolchains/gcc/lib64 -L/home/lixq/toolchains/binutils/lib -L/home/lixq/toolchains/curl/libs/openssl/lib -L/home/lixq/toolchains/curl/libs/nghttp3/lib -L/home/lixq/toolchains/curl/libs/ngtcp2/lib -L/home/lixq/toolchains/curl/libs/nghttp2/lib -L/home/lixq/toolchains/curl/lib -Wl,-rpath=/home/lixq/toolchains/gcc/lib64:/home/lixq/toolchains/binutils/lib:/home/lixq/toolchains/curl/libs/openssl/lib:/home/lixq/toolchains/curl/libs/nghttp3/lib:/home/lixq/toolchains/curl/libs/ngtcp2/lib:/home/lixq/toolchains/curl/libs/nghttp2/lib:/home/lixq/toolchains/curl/lib"

[[ -d /home/lixq/src ]] || mkdir /home/lixq/src
rm -rf /home/lixq/toolchains/curl

cd /home/lixq/src || exit 1
rm -rfv openssl-${opensslver}
tar -xf /home/lixq/35share-rd/src/openssl-${opensslver}.tar.gz
cd /home/lixq/src/openssl-${opensslver} || exit 1
[[ -d /home/lixq/toolchains/curl/libs/openssl ]] || mkdir -p /home/lixq/toolchains/curl/libs/openssl
./config --prefix=/home/lixq/toolchains/curl/libs/openssl --libdir=lib || exit 1
make || exit 1
make install || exit 1

cd /home/lixq/src || exit 1
rm -rfv nghttp3-${nghttp3ver}
tar -xf /home/lixq/35share-rd/src/nghttp3-${nghttp3ver}.tar.gz
cd /home/lixq/src/nghttp3-${nghttp3ver} || exit 1
autoreconf -fi || exit 1
[[ -d /home/lixq/toolchains/curl/libs/nghttp3 ]] || mkdir -p /home/lixq/toolchains/curl/libs/nghttp3
./configure --prefix=/home/lixq/toolchains/curl/libs/nghttp3 --enable-lib-only || exit 1
make || exit 1
make install || exit 1

cd /home/lixq/src || exit 1
rm -rfv ngtcp2-${ngtcp2ver}
tar -xf /home/lixq/35share-rd/src/ngtcp2-${ngtcp2ver}.tar.gz
cd /home/lixq/src/ngtcp2-${ngtcp2ver} || exit 1
autoreconf -fi || exit 1
[[ -d /home/lixq/toolchains/curl/libs/ngtcp2 ]] || mkdir -p /home/lixq/toolchains/curl/libs/ngtcp2
#./configure PKG_CONFIG_PATH=/home/lixq/toolchains/curl/libs/openssl/lib/pkgconfig:/home/lixq/toolchains/curl/libs/nghttp3/lib/pkgconfig LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/curl/libs/openssl/lib" --prefix=/home/lixq/toolchains/curl/libs/ngtcp2 --enable-lib-only --with-openssl || exit 1
./configure --prefix=/home/lixq/toolchains/curl/libs/ngtcp2 --enable-lib-only --with-openssl || exit 1
make || exit 1
make install || exit 1

cd /home/lixq/src || exit 1
rm -rfv nghttp2-${nghttp2ver}
tar -xf /home/lixq/35share-rd/src/nghttp2-${nghttp2ver}.tar.gz
cd /home/lixq/src/nghttp2-${nghttp2ver} || exit 1
[[ -d /home/lixq/toolchains/curl/libs/nghttp2 ]] || mkdir -p /home/lixq/toolchains/curl/libs/nghttp2
#PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/home/lixq/toolchains/curl/libs/openssl/lib/pkgconfig:/home/lixq/toolchains/curl/libs/nghttp3/lib/pkgconfig:/home/lixq/toolchains/curl/libs/ngtcp2/lib/pkgconfig LDFLAGS="-L/home/lixq/toolchains/curl/libs/openssl/lib -L/home/lixq/toolchains/curl/libs/nghttp3/lib -L/home/lixq/toolchains/curl/libs/ngtcp2/lib" CFLAGS="-I/home/lixq/toolchains/curl/libs/openssl/include -I/home/lixq/toolchains/curl/libs/nghttp3/include -I/home/lixq/toolchains/curl/libs/ngtcp2/include" ./configure --prefix=/home/lixq/toolchains/curl/libs/nghttp2 --enable-lib-only || exit 1
./configure --prefix=/home/lixq/toolchains/curl/libs/nghttp2 --enable-lib-only || exit 1
make || exit 1
make install || exit 1

cd /home/lixq/src || exit 1
rm -rfv curl-${ver}
tar -xf /home/lixq/35share-rd/src/curl-${ver}.tar.gz
cd /home/lixq/src/curl-${ver} || exit 1
autoreconf -fi || exit 1
#LDFLAGS="-Wl,-rpath,/home/lixq/toolchains/curl/libs/openssl/lib" ./configure --prefix=/home/lixq/toolchains/curl --with-openssl=/home/lixq/toolchains/curl/libs/openssl --with-nghttp3=/home/lixq/toolchains/curl/libs/nghttp3 --with-ngtcp2=/home/lixq/toolchains/curl/libs/ngtcp2 --with-nghttp2=/home/lixq/toolchains/curl/libs/nghttp2 || exit 1
./configure --prefix=/home/lixq/toolchains/curl --with-openssl=/home/lixq/toolchains/curl/libs/openssl --with-nghttp3=/home/lixq/toolchains/curl/libs/nghttp3 --with-ngtcp2=/home/lixq/toolchains/curl/libs/ngtcp2 --with-nghttp2=/home/lixq/toolchains/curl/libs/nghttp2 || exit 1
make || exit 1
make install || exit 1
