#!/bin/bash
date "+%Y-%m-%d %H:%M:%S begin" > /tmp/build_all.log
tab=$(date +%s)

# step 1 gcc
# binutils  2.45    https://mirrors.tuna.tsinghua.edu.cn/gnu/binutils/
# gcc       15.2.0  https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/
# ./contrib/download_prerequisites https://gcc.gnu.org/pub/gcc/infrastructure/
n=1
pkgs=(binutils gcc)
tsb=$(date +%s)
date "+%Y-%m-%d %H:%M:%S begin step $n ${pkgs[*]}" >> /tmp/build_all.log
for p in "${pkgs[@]}"; do
    [[ -d /home/lixq/toolchains/$p ]] && continue
    date "+%Y-%m-%d %H:%M:%S begin build toolchains $p" >> /tmp/build_all.log
    tb=$(date +%s)
    "/home/lixq/35share-rd/toolchains/buildsh/build_$p.sh" || exit 1
    te=$(date +%s)
    date "+%Y-%m-%d %H:%M:%S end   build toolchains $p use $((te - tb)) seconds" >> /tmp/build_all.log
done
touch /home/lixq/mintoolset.tar.$n
for td in toolset mintoolset; do
    [[ -f /home/lixq/$td.tar.$n ]] && continue
    rm -rf /home/lixq/$td
    cd /home/lixq || exit 1
    [[ -s $td.tar.$((n-1)) ]] && tar -xf $td.tar.$((n-1))
    for p in "${pkgs[@]}"; do
        date "+%Y-%m-%d %H:%M:%S begin build $td $p" >> /tmp/build_all.log
        tb=$(date +%s)
        "/home/lixq/35share-rd/toolchains/buildsh/build_$p.sh" /home/lixq/$td || exit 1
        te=$(date +%s)
        date "+%Y-%m-%d %H:%M:%S end   build $td $p use $((te - tb)) seconds" >> /tmp/build_all.log
    done
    cd /home/lixq || exit 1
    tar -cf $td.tar.$n $td
done
tse=$(date +%s)
date "+%Y-%m-%d %H:%M:%S end   step $n ${pkgs[*]} use $((tse - tsb)) seconds" >> /tmp/build_all.log

# step 2 cmake
# cmake    4.1.0   https://cmake.org/download/
cmakever=4.1.0
n=2
pkgs=(cmake)
tsb=$(date +%s)
date "+%Y-%m-%d %H:%M:%S begin step $n ${pkgs[*]}" >> /tmp/build_all.log
for d in /home/lixq/toolchains/cmake /home/lixq/toolset/usr; do
    [[ -x $d/bin/cmake ]] && continue
    date "+%Y-%m-%d %H:%M:%S begin build $(basename "$(dirname "$d")") cmake" >> /tmp/build_all.log
    tb=$(date +%s)
    [[ -d $d ]] || mkdir -p $d
    cd $d || exit 1
    tar -xf /home/lixq/src/cmake-${cmakever}-linux-x86_64.tar.gz --strip-components=1 || exit 1
    te=$(date +%s)
    date "+%Y-%m-%d %H:%M:%S end   build $(basename "$(dirname "$d")") cmake use $((te - tb)) seconds" >> /tmp/build_all.log
done
cp /home/lixq/mintoolset.tar.$((n-1)) /home/lixq/mintoolset.tar.$n
if [[ ! -f /home/lixq/toolset.tar.$n ]]; then
    cd /home/lixq || exit 1
    tar -cf toolset.tar.$n toolset
fi
tse=$(date +%s)
date "+%Y-%m-%d %H:%M:%S end   step $n ${pkgs[*]} use $((tse - tsb)) seconds" >> /tmp/build_all.log

# step 3 curl
# openssl       3.5.2   https://github.com/openssl/openssl/releases/
# nghttp3       1.11.0  https://github.com/ngtcp2/nghttp3/releases/
# ngtcp2        1.14.0  https://github.com/ngtcp2/ngtcp2/releases/
# nghttp2       1.66.0  https://github.com/nghttp2/nghttp2/releases/
# libssh2       1.11.1  https://libssh2.org/
# zlib          1.3.1   https://github.com/madler/zlib/releases/
# brotli        1.1.0   https://github.com/google/brotli/releases/
# zstd          1.5.7   https://github.com/facebook/zstd/releases/
# keyutils      1.6.3   https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/
# krb5          1.22.1  https://web.mit.edu/kerberos/dist/
# libidn2       2.3.8   https://mirrors.tuna.tsinghua.edu.cn/gnu/libidn/
# openldap      2.6.10  https://www.openldap.org/software/download/
# libunistring  1.3     https://mirrors.tuna.tsinghua.edu.cn/gnu/libunistring/
# libpsl        0.21.5  https://github.com/rockdaboot/libpsl/releases/
# gsasl         2.2.2   https://mirrors.tuna.tsinghua.edu.cn/gnu/gsasl/
# curl          8.15.0  https://github.com/curl/curl/releases/
n=3
pkgs=(openssl nghttp3 ngtcp2 nghttp2 libssh2 zlib brotli zstd keyutils krb5 libidn2 openldap libunistring libpsl gsasl curl)
tsb=$(date +%s)
date "+%Y-%m-%d %H:%M:%S begin step $n ${pkgs[*]}" >> /tmp/build_all.log
for p in "${pkgs[@]}"; do
    [[ -d /home/lixq/toolchains/$p ]] && continue
    date "+%Y-%m-%d %H:%M:%S begin build toolchains $p" >> /tmp/build_all.log
    tb=$(date +%s)
    "/home/lixq/35share-rd/toolchains/buildsh/build_$p.sh" || exit 1
    "/home/lixq/35share-rd/toolchains/buildsh/build_$p.sh" || exit 1
    te=$(date +%s)
    date "+%Y-%m-%d %H:%M:%S end   build toolchains $p use $((te - tb)) seconds" >> /tmp/build_all.log
done
for td in toolset mintoolset; do
    [[ -f /home/lixq/$td.tar.$n ]] && continue
    rm -rf /home/lixq/$td
    cd /home/lixq || exit 1
    [[ -s $td.tar.$((n-1)) ]] && tar -xf $td.tar.$((n-1))
    for p in "${pkgs[@]}"; do
        date "+%Y-%m-%d %H:%M:%S begin build $td $p" >> /tmp/build_all.log
        tb=$(date +%s)
        "/home/lixq/35share-rd/toolchains/buildsh/build_$p.sh" /home/lixq/$td || exit 1
        te=$(date +%s)
        date "+%Y-%m-%d %H:%M:%S end   build $td $p use $((te - tb)) seconds" >> /tmp/build_all.log
    done
    cd /home/lixq || exit 1
    tar -cf $td.tar.$n $td
done
tse=$(date +%s)
date "+%Y-%m-%d %H:%M:%S end   step $n ${pkgs[*]} use $((tse - tsb)) seconds" >> /tmp/build_all.log

# step 4 bashdb
# bashdb 4.4-1.0.1 https://sourceforge.net/projects/bashdb/files/bashdb/
n=4
pkgs=(bashdb)
tsb=$(date +%s)
date "+%Y-%m-%d %H:%M:%S begin step $n ${pkgs[*]}" >> /tmp/build_all.log
for p in "${pkgs[@]}"; do
    [[ -d /home/lixq/toolchains/$p ]] && continue
    date "+%Y-%m-%d %H:%M:%S begin build toolchains $p" >> /tmp/build_all.log
    tb=$(date +%s)
    "/home/lixq/35share-rd/toolchains/buildsh/build_$p.sh" || exit 1
    "/home/lixq/35share-rd/toolchains/buildsh/build_$p.sh" || exit 1
    te=$(date +%s)
    date "+%Y-%m-%d %H:%M:%S end   build toolchains $p use $((te - tb)) seconds" >> /tmp/build_all.log
done
cp /home/lixq/mintoolset.tar.$((n-1)) /home/lixq/mintoolset.tar.$n
for td in toolset mintoolset; do
    [[ -f /home/lixq/$td.tar.$n ]] && continue
    rm -rf /home/lixq/$td
    cd /home/lixq || exit 1
    [[ -s $td.tar.$((n-1)) ]] && tar -xf $td.tar.$((n-1))
    for p in "${pkgs[@]}"; do
        date "+%Y-%m-%d %H:%M:%S begin build $td $p" >> /tmp/build_all.log
        tb=$(date +%s)
        "/home/lixq/35share-rd/toolchains/buildsh/build_$p.sh" /home/lixq/$td || exit 1
        te=$(date +%s)
        date "+%Y-%m-%d %H:%M:%S end   build $td $p use $((te - tb)) seconds" >> /tmp/build_all.log
    done
    cd /home/lixq || exit 1
    tar -cf $td.tar.$n $td
done
tse=$(date +%s)
date "+%Y-%m-%d %H:%M:%S end   step $n ${pkgs[*]} use $((tse - tsb)) seconds" >> /tmp/build_all.log

tae=$(date +%s)
date "+%Y-%m-%d %H:%M:%S end   use $((tae - tab)) seconds" >> /tmp/build_all.log
