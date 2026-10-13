#!/bin/bash
set -euo pipefail
name=$(basename "${BASH_SOURCE[0]}" .sh)
name=${name#build_}
ver=$1
cpanm_ver=$2
DESTDIR=$3
srcpath=/share-rd/cdn_prd_cache/lixq/src/$name-$ver.tar.gz
cpanm_srcpath=/share-rd/cdn_prd_cache/lixq/src/App-cpanminus-$cpanm_ver.tar.gz
[[ -n $DESTDIR ]]
[[ -f $srcpath ]]

export MANPATH=
export PCP_DIR=
export LD_LIBRARY_PATH=
export PKG_CONFIG_PATH=
export INFOPATH=
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"

cd /home/lixq/src
rm -rf "$name-$ver"
tar -xf "$srcpath"
cd "/home/lixq/src/$name-$ver"
./Configure -des -Dusedevel -Dversiononly=no -Dprefix="$DESTDIR/usr"
make -s "-j$(nproc)"
make -s "-j$(nproc)" install

export http_proxy=http://repo.haplat.net:60028
export https_proxy=http://repo.haplat.net:60028
export all_proxy=http://repo.haplat.net:60028

cd /home/lixq/src
rm -rf build-cpanm
mkdir build-cpanm
tar -xf "$cpanm_srcpath" -C build-cpanm
cd "build-cpanm/App-cpanminus-$cpanm_ver"
"$DESTDIR/usr/bin/perl" Makefile.PL
make -s
make -s install

PERL_MM_USE_DEFAULT=1 "$DESTDIR/usr/bin/cpanm" --mirror "https://mirrors.ustc.edu.cn/CPAN" --mirror-only --notest Capture::Tiny DateTime Date::Parse Devel::StackTrace DateTime::Format::W3CDTF Memory::Process JSON::XS
