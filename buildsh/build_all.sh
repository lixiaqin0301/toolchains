#!/bin/bash
date "+%Y-%m-%d %H:%M:%S begin" > /tmp/build_all.log
tab=$(date +%s)

# step 1 gcc
# binutils  2.45    https://mirrors.tuna.tsinghua.edu.cn/gnu/binutils/
# gcc       15.2.0  https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/
n=1
touch /home/lixq/mintoolset.tar.$n
for td in toolset mintoolset; do
    [[ -f /home/lixq/$td.tar.$n ]] && continue
    rm -rf /home/lixq/$td
    for p in binutils gcc; do
        date "+%Y-%m-%d %H:%M:%S begin build $td $p" >> /tmp/build_all.log
        tb=$(date +%s)
        /home/lixq/35share-rd/toolchains/buildsh/build_$p.sh /home/lixq/$td || exit 1
        te=$(date +%s)
        date "+%Y-%m-%d %H:%M:%S end   build $td $p use $((te - tb)) seconds" >> /tmp/build_all.log
    done
    cd /home/lixq || exit 1
    tar -cf $td.tar.$n $td
done

# step 2 cmake
# cmake    4.1.0   https://cmake.org/download/
cmakever=4.1.0
n=2
cp /home/lixq/mintoolset.tar.$((n-1)) /home/lixq/mintoolset.tar.$n
for td in toolset mintoolset; do
    [[ -f /home/lixq/$td.tar.$n ]] && continue
    rm -rf /home/lixq/$td
    cd /home/lixq || exit 1
    [[ -s $td.tar.$((n-1)) ]] && tar -xf $td.tar.$((n-1))
    date "+%Y-%m-%d %H:%M:%S begin build $td cmake" >> /tmp/build_all.log
    tb=$(date +%s)
    cd /home/lixq/$td/usr || exit 1
    tar -xf /home/lixq/35share-rd/src/cmake-${cmakever}-linux-x86_64.tar.gz --strip-components=1
    te=$(date +%s)
    date "+%Y-%m-%d %H:%M:%S end   build $td cmake use $((te - tb)) seconds" >> /tmp/build_all.log
    cd /home/lixq || exit 1
    tar -cf $td.tar.$n $td
done

# step 3 curl
# openssl  3.5.2   https://github.com/openssl/openssl/releases/
# nghttp3  1.11.0  https://github.com/ngtcp2/nghttp3/releases/
# ngtcp2   1.14.0  https://github.com/ngtcp2/ngtcp2/releases/
# nghttp2  1.66.0  https://github.com/nghttp2/nghttp2/releases/
# libssh2  1.11.1  https://libssh2.org/
# zlib     1.3.1   https://github.com/madler/zlib/releases/
# brotli   1.1.0   https://github.com/google/brotli/releases/
# zstd     1.5.7   https://github.com/facebook/zstd/releases/
# krb5     1.22.1  https://web.mit.edu/kerberos/dist/
# libidn2  2.3.8   https://mirrors.tuna.tsinghua.edu.cn/gnu/libidn/
# libpsl   0.21.5  https://github.com/rockdaboot/libpsl/releases/
# gsasl    2.2.2   https://mirrors.tuna.tsinghua.edu.cn/gnu/gsasl/
# curl     8.15.0  https://github.com/curl/curl/releases/
n=3
cd /home/lixq || exit 1
for td in toolset mintoolset; do
    [[ -f /home/lixq/$td.tar.$n ]] && continue
    rm -rf /home/lixq/$td
    cd /home/lixq || exit 1
    [[ -s $td.tar.$((n-1)) ]] && tar -xf $td.tar.$((n-1))
    for p in openssl nghttp3 ngtcp2 nghttp2 libssh2 zlib brotli zstd krb5 libidn2 libpsl gsasl curl; do
        date "+%Y-%m-%d %H:%M:%S begin build $td $p" >> /tmp/build_all.log
        tb=$(date +%s)
        /home/lixq/35share-rd/toolchains/buildsh/build_$p.sh /home/lixq/$td || exit 1
        te=$(date +%s)
        date "+%Y-%m-%d %H:%M:%S end   build $td $p use $((te - tb)) seconds" >> /tmp/build_all.log
    done
    cd /home/lixq || exit 1
    tar -cf $td.tar.$n $td
done

tae=$(date +%s)
date "+%Y-%m-%d %H:%M:%S end   use $((tae - tab)) seconds" >> /tmp/build_all.log
